# Construye el jar y levanta tours-service en modo produccion.
# Si faltan Maven/Java locales, usa contenedores Docker.
Set-Location $PSScriptRoot\..

$projectPath = (Get-Location).Path
$hasMaven = $null -ne (Get-Command mvn -ErrorAction SilentlyContinue)
$hasJava = $null -ne (Get-Command java -ErrorAction SilentlyContinue)

if ($hasMaven -and $hasJava) {
		mvn clean package
		java -jar target\tours-service-1.0.0.jar
} else {
		Write-Host "Maven o Java no encontrados. Construyendo/ejecutando con Docker..."
		docker run --rm `
			-v "${projectPath}:/workspace" `
			-w /workspace `
			maven:3.9.9-eclipse-temurin-17 `
			mvn clean package

		docker run --rm -p 8091:8091 `
			-e DB_URL="jdbc:postgresql://host.docker.internal:5432/toursdb" `
			-e DB_USER="tours_user" `
			-e DB_PASSWORD="tours_pass" `
			-v "${projectPath}:/workspace" `
			-w /workspace `
			eclipse-temurin:17-jre `
			java -jar target/tours-service-1.0.0.jar
}
