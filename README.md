# scripts-and-things

Example scripts for calling APIs from the command line and focusing on subsets of JSON data.

## Requirements

- `bash`
- `curl`
- `jq`

## Scripts

### `/home/runner/work/scripts-and-things/scripts-and-things/scripts/query-api-json.sh`

Fetch JSON once and filter it with a `jq` expression.

Usage:

```bash
./scripts/query-api-json.sh <url> [jq-filter]
```

Examples:

```bash
./scripts/query-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things
./scripts/query-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things '{name: .name, stars: .stargazers_count}'
./scripts/query-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things '.owner.login'
```

### `/home/runner/work/scripts-and-things/scripts-and-things/scripts/watch-api-json.sh`

Continuously call an API endpoint and print filtered JSON output on an interval.

Usage:

```bash
./scripts/watch-api-json.sh <url> [jq-filter] [interval-seconds]
```

Examples:

```bash
./scripts/watch-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things
./scripts/watch-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things '.open_issues_count' 15
./scripts/watch-api-json.sh https://api.github.com/repos/jwilcox501/scripts-and-things '{updated_at: .updated_at, pushed_at: .pushed_at}' 30
```

Press `Ctrl+C` to stop the watch script.
