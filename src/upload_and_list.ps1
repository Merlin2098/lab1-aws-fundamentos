<#
Lab 1 - AWS CLI: crea (si hace falta) un bucket S3, sube un archivo y lista el contenido.

Uso:
    .\upload_and_list.ps1 -BucketName <nombre-bucket> -FilePath <ruta-archivo-local> [-Region <region>]

Ejemplo:
    .\upload_and_list.ps1 -BucketName bootcamp-da-rfuculmana -FilePath .\data\ejemplo.csv -Region us-east-1
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$BucketName,

    [Parameter(Mandatory = $true)]
    [string]$FilePath,

    [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $FilePath)) {
    Write-Error "No se encontró el archivo '$FilePath'"
    exit 1
}

Write-Host "==> Verificando identidad AWS..."
aws sts get-caller-identity

Write-Host "==> Verificando si el bucket '$BucketName' existe..."
aws s3api head-bucket --bucket $BucketName 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "El bucket ya existe, se reutiliza."
} else {
    Write-Host "Creando bucket '$BucketName' en región '$Region'..."
    aws s3 mb "s3://$BucketName" --region $Region
}

Write-Host "==> Subiendo '$FilePath' a s3://$BucketName/..."
aws s3 cp $FilePath "s3://$BucketName/"

Write-Host "==> Listando contenido de s3://$BucketName/..."
aws s3 ls "s3://$BucketName/" --recursive

Write-Host "Listo."
