#!/usr/bin/env bash
set -euo pipefail

# update-opencode-plugins.sh — update all OpenCode plugins and align versions in opencode.json
#
# OpenCode caches plugins in ~/.cache/opencode/packages/<name>@<version>/
#
# What this script does:
#   1. For each plugin in opencode.json "plugin" array:
#      a. Query npm registry for the latest version (fast, no install)
#      b. Reinstall the plugin in the cache dir with the new version
#   2. Rewrite the "plugin" array in opencode.json with the real latest versions
#
# Usage:
#   ./update-opencode-plugins.sh           # update all
#   ./update-opencode-plugins.sh --no-install  # only sync opencode.json versions, skip npm install

CONFIG_DIR="$HOME/.config/opencode"
OPENCODE_JSON="$CONFIG_DIR/opencode.json"
CACHE_DIR="$HOME/.cache/opencode/packages"
DO_INSTALL=true

[[ "${1:-}" == "--no-install" ]] && DO_INSTALL=false

[[ -f "$OPENCODE_JSON" ]] || { echo "✗ $OPENCODE_JSON not found" >&2; exit 1; }

mapfile -t PLUGIN_ENTRIES < <(jq -r '.plugin[]?' "$OPENCODE_JSON")

if [[ ${#PLUGIN_ENTRIES[@]} -eq 0 ]]; then
  echo "⚠ No plugins found in opencode.json; nothing to update"
  exit 0
fi

echo "🔧 Checking ${#PLUGIN_ENTRIES[@]} plugins for updates …"

NEW_PLUGINS_JSON="[]"

for entry in "${PLUGIN_ENTRIES[@]}"; do
  # Split name@version: for scoped packages (@scope/name@ver), split on last @
  if [[ "$entry" == @* ]]; then
    name="${entry%@*}"
    old_version="${entry##*@}"
  else
    name="${entry%@*}"
    old_version="${entry##*@}"
  fi

  # Query npm registry for latest version (fast, no install)
  latest_version=$(npm view "$name" version 2>/dev/null || echo "")

  if [[ -z "$latest_version" ]]; then
    echo "  ⚠ $name — could not reach npm registry; keeping @$old_version"
    NEW_PLUGINS_JSON=$(jq --arg p "${name}@${old_version}" '. + [$p]' <<< "$NEW_PLUGINS_JSON")
    continue
  fi

  if [[ "$latest_version" == "$old_version" ]]; then
    echo "  ✓ $name@$latest_version (up to date)"
  else
    echo "  ↑ $name: $old_version → $latest_version"
  fi

  # Reinstall in cache dir if requested
  if [[ "$DO_INSTALL" == true ]]; then
    cache_entry_dir="$CACHE_DIR/${name}@${latest_version}"
    # Remove old cache dirs for this plugin (any version)
    find "$CACHE_DIR" -maxdepth 1 -type d -name "${name}@*" -exec rm -rf {} + 2>/dev/null || true
    mkdir -p "$cache_entry_dir"
    (cd "$cache_entry_dir" && npm install "${name}@${latest_version}" 2>&1 | tail -1 | sed 's/^/      /') || {
      echo "  ⚠ npm install failed for $name; version still recorded in opencode.json" >&2
    }
  fi

  NEW_PLUGINS_JSON=$(jq --arg p "${name}@${latest_version}" '. + [$p]' <<< "$NEW_PLUGINS_JSON")
done

# Rewrite the plugin array in opencode.json
tmp="$OPENCODE_JSON.tmp"
jq --argjson plugins "$NEW_PLUGINS_JSON" '.plugin = $plugins' "$OPENCODE_JSON" > "$tmp" \
  && mv "$tmp" "$OPENCODE_JSON"

echo "✓ Done. opencode.json plugin array updated."
