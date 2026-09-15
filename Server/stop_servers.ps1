# Ensure Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 7 server executables in reverse shutdown order
$servers = @(
    "7. World.exe",
    "6. Cache.exe",
    "5. Login.exe",
    "4. Core.exe",
    "3. Database.exe",
    "2. Certifier.exe",
    "1. Account.exe"
)

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "          Stopping FlyFF v18 Server Cluster        " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

foreach ($serverName in $servers) {
    # Check if process exists
    $proc = Get-Process -Name ([System.IO.Path]::GetFileNameWithoutExtension($serverName)) -ErrorAction SilentlyContinue
    
    if ($proc) {
        Write-Host "`nStopping $serverName (PID: $($proc.Id))..." -ForegroundColor Yellow
        
        # Try graceful close first
        $proc.CloseMainWindow() | Out-Null
        Start-Sleep -Seconds 1
        
        # Force terminate if still open
        if (-not $proc.HasExited) {
            Stop-Process -Id $proc.Id -Force
            Write-Host "  [FORCED] $serverName terminated." -ForegroundColor Red
        } else {
            Write-Host "  [CLOSED] $serverName stopped cleanly." -ForegroundColor Green
        }
    } else {
        Write-Host "`n[SKIPPED] $serverName is not running." -ForegroundColor Gray
    }
}

Write-Host "`n===================================================" -ForegroundColor Green
Write-Host "   [SUCCESS] All FlyFF server processes stopped.    " -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Start-Sleep -Seconds 2