<#
Lab 1 - AWS CLI: crea (si hace falta) un bucket S3, sube todos los datasets
de data/ y lista el contenido.

Uso:
    .\upload_and_list.ps1 -BucketName <nombre-bucket> [-Region <region>]

Ejemplo:
    .\upload_and_list.ps1 -BucketName bootcamp-da-rfuculmana -Region us-east-1
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$BucketName,

    [string]$Region = "us-east-1"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$DataDir = Join-Path $ScriptDir "..\data"

$Datasets = @(
    "ventas.csv",
    "compras.csv",
    "movimientos_bancarios.csv"
)

foreach ($dataset in $Datasets) {
    $datasetPath = Join-Path $DataDir $dataset
    if (-not (Test-Path $datasetPath)) {
        Write-Error "No se encontró el archivo '$datasetPath'. Generalo antes con: python src/generate_datasets.py"
        exit 1
    }
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

foreach ($dataset in $Datasets) {
    $datasetPath = Join-Path $DataDir $dataset
    Write-Host "==> Subiendo '$dataset' a s3://$BucketName/..."
    aws s3 cp $datasetPath "s3://$BucketName/"
}

Write-Host "==> Listando contenido de s3://$BucketName/..."
aws s3 ls "s3://$BucketName/" --recursive

Write-Host "Listo."
