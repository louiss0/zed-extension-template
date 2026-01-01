#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 2 || $# -gt 3 ]]; then
	echo "Usage: $(basename "$0") <name> <email> [year]" >&2
	exit 2
fi

name="$1"
email="$2"
year="${3:-$(date +%Y)}"

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

extension_file="$repo_root/extension.toml"
license_file="$repo_root/LICENSE"

author_line="authors = [\"$name <$email>\"]"

tmp_extension="$extension_file.tmp"
awk -v line="$author_line" 'BEGIN { updated = 0 }
	/^authors = \[/ { print line; updated = 1; next }
	{ print }
	END { if (updated == 0) exit 1 }' "$extension_file" > "$tmp_extension"

mv "$tmp_extension" "$extension_file"

sed -i "s/^Copyright (c) [0-9][0-9][0-9][0-9] .*/Copyright (c) $year $name/" "$license_file"

echo "Updated $extension_file and $license_file"
