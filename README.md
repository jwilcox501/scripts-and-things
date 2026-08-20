# scripts-and-things

Example scripts for calling APIs from the command line and focusing on subsets of JSON data with PowerShell.

## Requirements

- PowerShell 7+

## Scripts

### `scripts/query-api-json.ps1`

Fetch JSON once and filter it with a PowerShell expression.

The optional filter is executed as PowerShell code. Only use trusted filter input.

Usage:

```powershell
./scripts/query-api-json.ps1 <url> [filter]
```

Examples:

```powershell
./scripts/query-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things
./scripts/query-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things '$InputObject | Select-Object name, stargazers_count'
./scripts/query-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things '$InputObject.owner.login'
```

### `scripts/watch-api-json.ps1`

Continuously call an API endpoint and print filtered JSON output on an interval.

The optional filter is executed as PowerShell code. Only use trusted filter input.

Usage:

```powershell
./scripts/watch-api-json.ps1 <url> [filter] [interval-seconds]
```

Examples:

```powershell
./scripts/watch-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things
./scripts/watch-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things '$InputObject.open_issues_count' 15
./scripts/watch-api-json.ps1 https://api.github.com/repos/jwilcox501/scripts-and-things '$InputObject | Select-Object updated_at, pushed_at' 30
```

Press `Ctrl+C` to stop the watch script.
