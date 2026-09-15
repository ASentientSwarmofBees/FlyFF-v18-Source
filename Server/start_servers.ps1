# Ensure Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$ProgDir = Join-Path $PSScriptRoot "Program"
$ResDir  = Join-Path $PSScriptRoot "Resource"
$WaitTime = 5

$servers = @(
    @{ Name = "1. Account.exe";  Dir = $ProgDir; Title = "AccountServer" },
    @{ Name = "2. Certifier.exe"; Dir = $ProgDir; Title = "Certifier" },
    @{ Name = "3. Database.exe";  Dir = $ResDir;  Title = "DatabaseServer" },
    @{ Name = "4. Core.exe";      Dir = $ProgDir; Title = "CoreServer" },
    @{ Name = "5. Login.exe";     Dir = $ProgDir; Title = "LoginServer" },
    @{ Name = "6. Cache.exe";     Dir = $ProgDir; Title = "CacheServer" },
    @{ Name = "7. World.exe";     Dir = $ResDir;  Title = "WorldServer" }
)

Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "          Starting FlyFF v18 Server Cluster        " -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

foreach ($server in $servers) {
    Write-Host "`n[$($server.Title)] Starting $($server.Name)..." -ForegroundColor Yellow
    
    # Launch process with working directory set
    $proc = Start-Process -FilePath (Join-Path $server.Dir $server.Name) -WorkingDirectory $server.Dir -PassThru
    
    Write-Host "[$($server.Title)] Waiting $WaitTime seconds for initialization..." -ForegroundColor Gray
    Start-Sleep -Seconds $WaitTime
    
    # Verify process is still running
    if (-not $proc.HasExited) {
        Write-Host "[$($server.Title)] SUCCESS: Process active (PID: $($proc.Id))" -ForegroundColor Green
    } else {
        Write-Host "`n[ERROR] $($server.Title) ($($server.Name)) closed unexpectedly!" -ForegroundColor Red
        Write-Host "Check the error logs inside: $($server.Dir)" -ForegroundColor Red
        Write-Host "`nLaunch sequence halted." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
}

Write-Host "`n===================================================" -ForegroundColor Green
Write-Host "   [SUCCESS] All 7 server processes are running!    " -ForegroundColor Green
Write-Host "===================================================" -ForegroundColor Green
Read-Host "Press Enter to close this monitor window"