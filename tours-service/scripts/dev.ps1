# Ejecuta tours-service usando PostgreSQL por defecto.
# Modo desarrollo rapido con mn:run.
Set-Location $PSScriptRoot\..

$projectPath = (Get-Location).Path
$hasMaven = $null -ne (Get-Command mvn -ErrorAction SilentlyContinue)

if ($hasMaven) {
		mvn mn:run
} else {
		Write-Host "Maven no encontrado. Ejecutando mn:run con Maven en Docker..."
		docker run --rm -p 8091:8091 `
	  -e DB_URL="jdbc:postgresql://host.docker.internal:5432/toursdb" `
	  -e DB_USER="tours_user" `
	  -e DB_PASSWORD="tours_pass" `
	  -v "${projectPath}:/workspace" `
	  -w /workspace `
			maven:3.9.9-eclipse-temurin-17 `
			mvn mn:run
}
