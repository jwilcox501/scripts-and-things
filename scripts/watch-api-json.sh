#!/usr/bin/env bash
set -uo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <url> [jq-filter] [interval-seconds]"
  echo "Example: $0 https://api.github.com/repos/jwilcox501/scripts-and-things '.owner.login' 30"
  exit 1
fi

URL="$1"
JQ_FILTER="${2:-.}"
INTERVAL="${3:-10}"

if ! command -v curl >/dev/null 2>&1; then
  echo "Error: curl is required." >&2
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required." >&2
  exit 1
fi

if ! [[ "$INTERVAL" =~ ^[1-9][0-9]*$ ]]; then
  echo "Error: interval must be a positive integer." >&2
  exit 1
fi

while true; do
  printf '\n[%s] %s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" "$URL"

  if ! RESPONSE="$(curl -fsSL "$URL")"; then
    echo "Request failed for URL: $URL" >&2
  elif ! jq "$JQ_FILTER" <<<"$RESPONSE"; then
    echo "jq filter failed for URL: $URL" >&2
  fi

  sleep "$INTERVAL"
done
