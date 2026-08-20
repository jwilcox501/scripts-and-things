#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Url,

    [Parameter(Position = 1)]
    [string]$Filter = '$InputObject'
)

function Write-ApiResult {
    param(
        [Parameter(ValueFromPipeline = $true)]
        $Value
    )

    process {
        if ($null -eq $Value) {
            return
        }

        if ($Value -is [string] -or $Value -is [ValueType]) {
            Write-Output $Value
            return
        }

        $Value | ConvertTo-Json -Depth 100
    }
}

function Get-ApiResponse {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RequestUrl
    )

    Invoke-RestMethod -Uri $RequestUrl -Headers @{
        Accept     = 'application/json'
        'User-Agent' = 'scripts-and-things-powershell'
    }
}

try {
    # The filter is executed as PowerShell code; only pass trusted input.
    $FilterBlock = [scriptblock]::Create("param(`$InputObject) $Filter")
} catch {
    Write-Error "Filter parsing failed: $($_.Exception.Message)"
    exit 1
}

try {
    $Response = Get-ApiResponse -RequestUrl $Url
} catch {
    Write-Error "Request failed for URL '$Url': $($_.Exception.Message)"
    exit 1
}

try {
    & $FilterBlock $Response | Write-ApiResult
} catch {
    Write-Error "Filter execution failed for URL '$Url': $($_.Exception.Message)"
    exit 1
}
