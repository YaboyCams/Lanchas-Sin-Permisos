# Script opcional para levantar DB y abrir 2 terminales con backend + frontend.
Set-Location $PSScriptRoot
docker compose up -d postgres
Start-Process powershell -ArgumentList '-NoExit', '-Command', 'Set-Location "./tours-service"; ./scripts/dev.ps1'
Start-Process powershell -ArgumentList '-NoExit', '-Command', 'Set-Location "./frontend"; ./scripts/dev.ps1'
