#!/usr/bin/env bash
# Lab 1 - AWS CLI: crea (si hace falta) un bucket S3, sube todos los datasets
# de data/ y lista el contenido.
#
# Uso:
#   ./upload_and_list.sh <nombre-bucket> [region]
#
# Ejemplo:
#   ./upload_and_list.sh bootcamp-da-rfuculmana us-east-1

set -euo pipefail

BUCKET_NAME="${1:?Uso: $0 <nombre-bucket> [region]}"
REGION="${2:-us-east-1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$SCRIPT_DIR/../data"

DATASETS=(
  "ventas.csv"
  "compras.csv"
  "movimientos_bancarios.csv"
)

for dataset in "${DATASETS[@]}"; do
  if [[ ! -f "$DATA_DIR/$dataset" ]]; then
    echo "Error: no se encontró el archivo '$DATA_DIR/$dataset'" >&2
    echo "Generalo antes con: python src/generate_datasets.py" >&2
    exit 1
  fi
done

echo "==> Verificando identidad AWS..."
aws sts get-caller-identity

echo "==> Verificando si el bucket '$BUCKET_NAME' existe..."
if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
  echo "El bucket ya existe, se reutiliza."
else
  echo "Creando bucket '$BUCKET_NAME' en región '$REGION'..."
  aws s3 mb "s3://$BUCKET_NAME" --region "$REGION"
fi

for dataset in "${DATASETS[@]}"; do
  echo "==> Subiendo '$dataset' a s3://$BUCKET_NAME/..."
  aws s3 cp "$DATA_DIR/$dataset" "s3://$BUCKET_NAME/"
done

echo "==> Listando contenido de s3://$BUCKET_NAME/..."
aws s3 ls "s3://$BUCKET_NAME/" --recursive

echo "Listo."
