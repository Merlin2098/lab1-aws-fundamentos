# Lab 1 — AWS CLI: subir y listar archivos en S3

Primer laboratorio del bootcamp. El objetivo es que cada alumno use el AWS
CLI para crear un bucket S3, subir un archivo y listar el contenido del
bucket.

## Requisitos previos

- Cuenta de AWS con acceso a S3 (credenciales de IAM, no la cuenta root).
- AWS CLI v2 instalado. Verificar con:

```bash
aws --version
```

Si no está instalado, seguir la guía oficial:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## 1. Configurar credenciales

Hay dos formas de configurar las credenciales: con `aws configure` (perfil
persistente, ver abajo) o con variables de entorno a partir de un archivo
`.env.credentials` — ver [lab1-aws-credentials.md](lab1-aws-credentials.md)
para esa opción, incluyendo cómo validarlas en PowerShell y Git Bash.

Cada alumno configura su propio perfil con sus access keys (Access Key ID y
Secret Access Key, entregadas o generadas en IAM):

```bash
aws configure
```

Va a pedir cuatro datos:

```
AWS Access Key ID [None]: <tu access key id>
AWS Secret Access Key [None]: <tu secret access key>
Default region name [None]: us-east-1
Default output format [None]: json
```

Esto guarda las credenciales en `~/.aws/credentials` y la configuración en
`~/.aws/config`.

Verificar que quedaron bien configuradas:

```bash
aws sts get-caller-identity
```

Debe devolver el `Account`, `UserId` y `Arn` del usuario IAM — si devuelve
un error, revisar las keys o la región.

## 2. Crear el bucket

Los nombres de bucket en S3 son **globales y únicos** en todo AWS, así que
cada alumno debe usar un nombre propio (por ejemplo, con su usuario o un
sufijo aleatorio):

```bash
aws s3 mb s3://<nombre-del-bucket> --region us-east-1
```

Ejemplo:

```bash
aws s3 mb s3://bootcamp-da-rfuculmana --region us-east-1
```

## 3. Subir un archivo (upload)

```bash
aws s3 cp <ruta-archivo-local> s3://<nombre-del-bucket>/
```

Ejemplo:

```bash
aws s3 cp ./data/ejemplo.csv s3://bootcamp-da-rfuculmana/
```

También se puede subir a una "carpeta" (prefijo) dentro del bucket:

```bash
aws s3 cp ./data/ejemplo.csv s3://bootcamp-da-rfuculmana/raw/ejemplo.csv
```

## 4. Listar objetos del bucket

Listar el contenido del bucket completo:

```bash
aws s3 ls s3://<nombre-del-bucket>/
```

Listar de forma recursiva (incluye subcarpetas/prefijos):

```bash
aws s3 ls s3://<nombre-del-bucket>/ --recursive
```

Ejemplo de salida:

```
2026-09-13 10:15:32       1024 ejemplo.csv
```

## Resumen de comandos

| Acción                  | Comando                                                    |
|--------------------------|-------------------------------------------------------------|
| Verificar identidad       | `aws sts get-caller-identity`                              |
| Crear bucket              | `aws s3 mb s3://<bucket> --region us-east-1`                |
| Subir archivo              | `aws s3 cp <archivo-local> s3://<bucket>/`                  |
| Listar objetos             | `aws s3 ls s3://<bucket>/ --recursive`                      |

## Scripts alternativos

Si prefieren no escribir cada comando a mano, en [`src/`](../src/) hay
scripts que automatizan la subida y el listado:

- `src/upload_and_list.sh` (bash)
- `src/upload_and_list.ps1` (PowerShell)

Ver las instrucciones de uso dentro de cada script o en su comentario de
cabecera.
