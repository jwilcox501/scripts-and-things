#!/usr/bin/env pwsh

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Url,

    [Parameter(Position = 1)]
    [string]$Filter = '$InputObject',

    [Parameter(Position = 2)]
    [ValidateRange(1, [int]::MaxValue)]
    [int]$IntervalSeconds = 10
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

while ($true) {
    Write-Host ""
    Write-Output ("[{0}] {1}" -f (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ"), $Url)

    try {
        $Response = Get-ApiResponse -RequestUrl $Url
        & $FilterBlock $Response | Write-ApiResult
    } catch {
        Write-Error "Request or filter failed for URL '$Url': $($_.Exception.Message)"
    }

    Start-Sleep -Seconds $IntervalSeconds
}
