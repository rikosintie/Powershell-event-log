<#
.SYNOPSIS
    Extracts Windows Error Reporting (WER) crash events for nmap.exe
    from the Application event log and exports key crash details to CSV.

.DESCRIPTION
    Queries the Application log for events from "Windows Error Reporting"
    containing "nmap.exe" in event data. Parses common WER message fields:
      - Faulting Application
      - Faulting Module
      - Exception Code
    Exports results to a CSV file in the current user's profile.

    Designed to run on locked-down Windows systems:
      - No admin rights required
      - No external tools needed
      - Safe if no events exist

.OUTPUT
    CSV file: %USERPROFILE%\nmap_crash_report.csv

.EXAMPLE
    PS C:\> .\Get-NmapWerCrashes.ps1

    Report saved to:
    C:\Users\<user>\nmap_crash_report.csv
#>

Write-Host "Searching Windows Error Reporting events for nmap.exe..." -ForegroundColor Cyan

# Query WER events safely
$events = Get-WinEvent -FilterHashTable @{
    LogName      = "Application"
    ProviderName = "Windows Error Reporting"
    Data         = "nmap.exe"
} -ErrorAction SilentlyContinue

# Helper: Extract named field from WER message text
function Get-FieldValue {
    param($Message, $FieldName)

    $line = ($Message -split "`r?`n") | Where-Object { $_ -match $FieldName }
    if ($line) {
        return ($line -split ":",2)[1].Trim()
    }
    return ""
}

# Build report objects
$report = foreach ($event in $events) {
    $msg = $event.Message

    [PSCustomObject]@{
        TimeCreated    = $event.TimeCreated
        EventID        = $event.Id
        FaultingApp    = Get-FieldValue $msg "Faulting application name"
        FaultingModule= Get-FieldValue $msg "Faulting module name"
        ExceptionCode = Get-FieldValue $msg "Exception code"
    }
}

# Output path
$path = "$env:USERPROFILE\nmap_crash_report.csv"

# Export CSV (even if empty — still valid)
$report | Export-Csv -NoTypeInformation -Path $path

# Friendly summary
if ($report.Count -gt 0) {
    Write-Host "Found $($report.Count) Nmap crash event(s)." -ForegroundColor Green
} else {
    Write-Host "No Nmap crash events found." -ForegroundColor Yellow
}

Write-Host "Report saved to:" -NoNewline
Write-Host " $path" -ForegroundColor Cyan


Get-WinEvent -FilterHashTable @{LogName="Application"; ProviderName="Windows Error Reporting"; data="nmap.exe"} | Format-List
