#!/usr/bin/env bash
# Lab 0 - AWS CLI: crea (si hace falta) un bucket S3, sube un archivo y lista el contenido.
#
# Uso:
#   ./upload_and_list.sh <nombre-bucket> <ruta-archivo-local> [region]
#
# Ejemplo:
#   ./upload_and_list.sh bootcamp-da-rfuculmana ./data/ejemplo.csv us-east-1

set -euo pipefail

BUCKET_NAME="${1:?Uso: $0 <nombre-bucket> <ruta-archivo-local> [region]}"
FILE_PATH="${2:?Uso: $0 <nombre-bucket> <ruta-archivo-local> [region]}"
REGION="${3:-us-east-1}"

if [[ ! -f "$FILE_PATH" ]]; then
  echo "Error: no se encontró el archivo '$FILE_PATH'" >&2
  exit 1
fi

echo "==> Verificando identidad AWS..."
aws sts get-caller-identity

echo "==> Verificando si el bucket '$BUCKET_NAME' existe..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "El bucket ya existe, se reutiliza."
else
  echo "Creando bucket '$BUCKET_NAME' en región '$REGION'..."
  aws s3 mb "s3://$BUCKET_NAME" --region "$REGION"
fi

echo "==> Subiendo '$FILE_PATH' a s3://$BUCKET_NAME/..."
aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/"

echo "==> Listando contenido de s3://$BUCKET_NAME/..."
aws s3 ls "s3://$BUCKET_NAME/" --recursive

echo "Listo."
