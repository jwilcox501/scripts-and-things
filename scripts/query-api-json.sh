#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <url> [jq-filter]"
  echo "Example: $0 https://api.github.com/repos/jwilcox501/scripts-and-things '{name: .name, stars: .stargazers_count}'"
  exit 1
fi

URL="$1"
JQ_FILTER="${2:-.}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required." >&2
  exit 1
fi

curl -fsSL "$URL" | jq "$JQ_FILTER"
