#!/usr/bin/env bash
set -euo pipefail

# opencode-update-plugins.sh — update all OpenCode plugins: sync opencode.json AND install
#
# OpenCode loads plugins from <plugin_root>/node_modules/ where <plugin_root> is:
#   - ~/.cache/opencode/   (opencode 1.18+ / Desktop v21+)
#   - ~/.config/opencode/  (older opencode)
# OpenCode maintains a synthetic package.json there and runs `bun install` on startup.
# This script does the same install proactively so new versions are ready immediately.
#
# Usage:
#   ./opencode-update-plugins.sh               # update JSON + install
#   ./opencode-update-plugins.sh --no-install  # only sync opencode.json versions

CONFIG_DIR="$HOME/.config/opencode"
OPENCODE_JSON="$CONFIG_DIR/opencode.json"
DO_INSTALL=true

[[ "${1:-}" == "--no-install" ]] && DO_INSTALL=false

# Detect where opencode actually installs plugins
if [[ -f "$HOME/.cache/opencode/package.json" ]]; then
  PLUGIN_ROOT="$HOME/.cache/opencode"
elif [[ -f "$CONFIG_DIR/package.json" ]]; then
  PLUGIN_ROOT="$CONFIG_DIR"
else
  PLUGIN_ROOT=""
fi

[[ -f "$OPENCODE_JSON" ]] || { echo "✗ $OPENCODE_JSON not found" >&2; exit 1; }

mapfile -t PLUGIN_ENTRIES < <(jq -r '.plugin[]?' "$OPENCODE_JSON")

if [[ ${#PLUGIN_ENTRIES[@]} -eq 0 ]]; then
  echo "⚠ No plugins found in opencode.json; nothing to update"
  exit 0
fi

echo "🔧 Checking ${#PLUGIN_ENTRIES[@]} plugins for updates …"

NEW_PLUGINS_JSON="[]"
UPDATED=()

for entry in "${PLUGIN_ENTRIES[@]}"; do
  # Split name@version on the last @ (handles scoped packages like @scope/name@ver)
  name="${entry%@*}"
  old_version="${entry##*@}"

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
    UPDATED+=("${name}@${latest_version}")
  fi

  NEW_PLUGINS_JSON=$(jq --arg p "${name}@${latest_version}" '. + [$p]' <<< "$NEW_PLUGINS_JSON")
done

# Rewrite the plugin array in opencode.json
tmp="$OPENCODE_JSON.tmp"
jq --argjson plugins "$NEW_PLUGINS_JSON" '.plugin = $plugins' "$OPENCODE_JSON" > "$tmp" \
  && mv "$tmp" "$OPENCODE_JSON"
echo "✓ opencode.json updated."

# Install new versions to opencode's plugin root
if [[ "$DO_INSTALL" != true ]]; then
  echo "✓ Done (--no-install)."
  exit 0
fi

if [[ -z "$PLUGIN_ROOT" ]]; then
  echo "⚠ No plugin install location found (neither ~/.cache/opencode/ nor ~/.config/opencode/ has package.json)"
  echo "  Restart opencode to install the new versions."
  exit 0
fi

if [[ ${#UPDATED[@]} -eq 0 ]]; then
  echo "✓ Done. All plugins already up to date."
  exit 0
fi

if ! command -v bun >/dev/null 2>&1; then
  echo "⚠ bun not found on PATH; skipping install. Restart opencode to install."
  exit 0
fi

echo "📦 Installing ${#UPDATED[@]} updated plugin(s) in $PLUGIN_ROOT …"
for spec in "${UPDATED[@]}"; do
  (cd "$PLUGIN_ROOT" && bun add "$spec" 2>&1 | tail -1 | sed 's/^/  /') \
    || echo "  ⚠ bun add failed for $spec" >&2
done
echo "✓ Done. Plugins installed — restart opencode to load the new versions."
