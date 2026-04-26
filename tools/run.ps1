param (
    [Parameter(Mandatory=$false)]
    [string]$File = ".\src\main.bas",
    
    [Parameter(Mandatory=$false)]
    [switch]$CompileOnly
)

# Script para ejecutar programas de QBasic usando QB64 (Recomendado para Windows modernos)

$QB64_Path = "C:\qb64\qb64.exe" # Cambiar esto a la ruta real de tu instalación de QB64

Write-Host "--- Entorno de Ejecución QBasic ---" -ForegroundColor Cyan

if (-Not (Test-Path $File)) {
    Write-Host "Error: No se encontró el archivo '$File'" -ForegroundColor Red
    Write-Host "Asegúrate de que la ruta sea correcta."
    exit 1
}

if (Test-Path $QB64_Path) {
    if ($CompileOnly) {
        Write-Host "Compilando $File..." -ForegroundColor Yellow
        & $QB64_Path -c $File -o ".\build\$( [System.IO.Path]::GetFileNameWithoutExtension($File) ).exe"
        Write-Host "Compilación finalizada. Revisa la carpeta ./build/" -ForegroundColor Green
    } else {
        Write-Host "Ejecutando $File..." -ForegroundColor Green
        # Compila y ejecuta
        & $QB64_Path -c $File -x
    }
} else {
    Write-Host "No se encontró QB64 en la ruta especificada ($QB64_Path)." -ForegroundColor Yellow
    Write-Host "Si tienes un emulador como DOSBox, puedes configurarlo aquí."
    Write-Host ""
    Write-Host "Para la mejor experiencia en Windows 10/11, te recomendamos instalar QB64:"
    Write-Host "1. Ve a https://qb64.com/ y descarga la última versión."
    Write-Host "2. Extrae la carpeta en C:\qb64\"
    Write-Host "3. Vuelve a ejecutar este script."
    
    Write-Host ""
    Write-Host "Contenido del archivo $File (Vista Previa):" -ForegroundColor Gray
    Get-Content $File | Select-Object -First 10
}
