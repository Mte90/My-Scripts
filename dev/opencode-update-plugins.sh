#!/usr/bin/env bash
set -euo pipefail

# opencode-update-plugins.sh — update all OpenCode plugins: sync opencode.json AND install
#
# OpenCode loads plugins from <plugin_root>/packages/ where <plugin_root> is:
#   - ~/.cache/opencode/   (opencode 1.18+ / Desktop v21+)
#   - ~/.config/opencode/  (older opencode)
# Plugins are stored as scoped @org/name/ or unscoped name@version/ directories.
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

mapfile -t PLUGIN_ENTRIES < <(jq -c '.plugin[]?' "$OPENCODE_JSON")

if [[ ${#PLUGIN_ENTRIES[@]} -eq 0 ]]; then
  echo "⚠ No plugins found in opencode.json; nothing to update"
  exit 0
fi

echo "🔧 Checking ${#PLUGIN_ENTRIES[@]} plugins for updates …"

NEW_PLUGINS_JSON="[]"
UPDATED=()

for entry in "${PLUGIN_ENTRIES[@]}"; do
  # Branch on entry shape: tuple ["name@ver", {...}], object {...}, or plain string "name@ver"
  # Strip surrounding quotes from jq -c output for plain strings
  entry="${entry#\"}"
  entry="${entry%\"}"
  
  if [[ "$entry" == \[* ]]; then
    # Tuple entry: ["name@version", {options...}]
    spec=$(jq -r '.[0]' <<< "$entry")
    
    # Validate spec is a name@version string
    if [[ ! "$spec" =~ @ ]]; then
      echo "  ⚠ Unknown tuple format; keeping verbatim: $spec"
      NEW_PLUGINS_JSON=$(jq --argjson e "$entry" '. + [$e]' <<< "$NEW_PLUGINS_JSON")
      continue
    fi
    
    name="${spec%@*}"
    old_version="${spec##*@}"
    
    latest_version=$(npm view "$name" version 2>/dev/null || echo "")
    
    if [[ -z "$latest_version" ]]; then
      echo "  ⚠ $name — could not reach npm registry; keeping @$old_version"
      updated_spec="${name}@${old_version}"
    else
      if [[ "$latest_version" == "$old_version" ]]; then
        echo "  ✓ $name@$latest_version (up to date)"
      else
        echo "  ↑ $name: $old_version → $latest_version"
        UPDATED+=("${name}@${latest_version}")
      fi
      updated_spec="${name}@${latest_version}"
    fi
    
    # Rebuild tuple with updated version, preserving options
    options=$(jq '.[1:]' <<< "$entry")
    updated_entry=$(jq -n --arg spec "$updated_spec" --argjson opts "$options" '[$spec] + $opts')
    NEW_PLUGINS_JSON=$(jq --argjson e "$updated_entry" '. + [$e]' <<< "$NEW_PLUGINS_JSON")
    continue
  fi
  
  if [[ "$entry" == \{* ]]; then
    # Unknown object entry — keep verbatim, warn
    echo "  ⚠ Unknown object entry; keeping verbatim"
    NEW_PLUGINS_JSON=$(jq --argjson e "$entry" '. + [$e]' <<< "$NEW_PLUGINS_JSON")
    continue
  fi
  
  # Plain string entry: "name@version"
  if [[ ! "$entry" =~ @ ]]; then
    echo "  ⚠ Entry missing @; keeping verbatim: $entry"
    NEW_PLUGINS_JSON=$(jq --arg p "$entry" '. + [$p]' <<< "$NEW_PLUGINS_JSON")
    continue
  fi
  
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

if ! command -v npm >/dev/null 2>&1; then
  echo "⚠ npm not found on PATH; skipping install. Restart opencode to install."
  exit 0
fi

if [[ ! -d "$PLUGIN_ROOT/packages" ]]; then
  echo "⚠ Plugins directory not found: $PLUGIN_ROOT/packages"
  echo "  Restart opencode to create the directory."
  exit 1
fi

echo "📦 Installing ${#UPDATED[@]} updated plugin(s) in $PLUGIN_ROOT/packages …"

for spec in "${UPDATED[@]}"; do
  # Extract package name and version
  name="${spec%@*}"
  version="${spec##*@}"
  
  # Remove stale "<name>@latest" dir if present (leftover from tag-based
  # installs); safe here because UPDATED specs are all concrete versions
  latest_dir="$PLUGIN_ROOT/packages/${name}@latest"
  if [[ -d "$latest_dir" ]]; then
    rm -rf "$latest_dir"
    echo "  🗑 Removed stale dir: ${name}@latest"
  fi
  
  # Directory name is always name@version (matches opencode's layout for both scoped and unscoped)
  dir_name="${name}@${version}"
  
  target_dir="$PLUGIN_ROOT/packages/$dir_name"
  
  echo "  Installing $spec → $dir_name/"
  
  # Remove old version if exists
  rm -rf "$target_dir"
  mkdir -p "$target_dir"
  
  # Create wrapper package.json matching opencode's layout:
  #   <plugin_root>/packages/<name>@<ver>/package.json        (wrapper: {"dependencies":{"<name>":"<ver>"}})
  #   <plugin_root>/packages/<name>@<ver>/node_modules/<name>/ (actual plugin + transitive deps)
  echo "{\"dependencies\":{\"$name\":\"$version\"}}" > "$target_dir/package.json"
  
  # Install — resolves the plugin and all its transitive dependencies into node_modules/
  if (cd "$target_dir" && npm install --no-audit --no-fund --loglevel=error 2>&1); then
    echo "    ✓ Installed to $dir_name/"
  else
    echo "    ⚠ npm install failed for $spec; removing partial directory"
    rm -rf "$target_dir"
  fi
done

echo "✓ Done. Plugins installed — restart opencode to load the new versions."
