$ErrorActionPreference = "Stop"

Write-Host "MedReminder project setup" -ForegroundColor Green
if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  Write-Error "Flutter was not found on PATH. Install Flutter and reopen PowerShell."
}

if (-not (Test-Path "android") -or -not (Test-Path "windows")) {
  Write-Host "Generating standard Android and Windows runner folders..."
  flutter create --platforms=android,windows .
}

flutter pub get
Write-Host ""
Write-Host "Setup complete. Run one of these commands:" -ForegroundColor Green
Write-Host "  flutter devices"
Write-Host "  flutter run -d <device-id>"
Write-Host "  flutter run -d windows"
