# Lab 1 — Configurar credenciales de AWS (env vars)

Guía alternativa a `aws configure` para setear las credenciales de AWS como
**variables de entorno** en la sesión de terminal, a partir de un archivo de
credenciales tipo `.env`. Cubre PowerShell y Git Bash.

Esta forma es útil cuando no querés persistir las credenciales en
`~/.aws/credentials`, o cuando estás usando un archivo de entorno provisto
por el instructor (por ejemplo `.env.credentials`).

## 0. Archivo de credenciales

El archivo de entorno tiene este formato (ver `.env.example` en la raíz del
repo como plantilla):

```
AWS_ACCESS_KEY_ID=<tu-access-key-id>
AWS_SECRET_ACCESS_KEY=<tu-secret-access-key>
AWS_SESSION_TOKEN=
AWS_DEFAULT_REGION=us-east-1
```

`AWS_SESSION_TOKEN` solo es necesario si te dieron credenciales temporales
(por ejemplo, un rol asumido o AWS Academy/Learner Lab). Si no aplica,
dejalo vacío o no lo definas.

> **Importante:** nunca subas a git un archivo con credenciales reales.
> Los archivos `.env` y `.env.*` ya están en `.gitignore` en este repo —
> mantenelos así, y si llegás a exponer una key por error, rotala
> inmediatamente en IAM.

## 1. Setear las variables de entorno

### Opción A — Git Bash

Si tenés un archivo `.env.credentials` con el formato de arriba, podés
cargarlo directamente en la sesión actual:

```bash
set -a
source .env.credentials
set +a
```

`set -a` hace que todas las variables definidas por `source` se exporten
automáticamente al entorno (no solo queden como variables locales del
script).

Alternativa, seteando cada variable a mano:

```bash
export AWS_ACCESS_KEY_ID="<tu-access-key-id>"
export AWS_SECRET_ACCESS_KEY="<tu-secret-access-key>"
export AWS_DEFAULT_REGION="us-east-1"
# Solo si tenés credenciales temporales:
export AWS_SESSION_TOKEN="<tu-session-token>"
```

Estas variables solo viven en la sesión actual de la terminal. Si cerrás la
terminal, hay que volver a setearlas.

### Opción B — PowerShell

PowerShell no tiene un equivalente directo a `source`, así que se puede
parsear el archivo `.env.credentials` línea por línea:

```powershell
Get-Content .env.credentials | ForEach-Object {
    if ($_ -match '^\s*#' -or $_ -match '^\s*$') { return }
    $name, $value = $_.Split('=', 2)
    if ($value) {
        Set-Item -Path "Env:$name" -Value $value
    }
}
```

Alternativa, seteando cada variable a mano:

```powershell
$env:AWS_ACCESS_KEY_ID = "<tu-access-key-id>"
$env:AWS_SECRET_ACCESS_KEY = "<tu-secret-access-key>"
$env:AWS_DEFAULT_REGION = "us-east-1"
# Solo si tenés credenciales temporales:
$env:AWS_SESSION_TOKEN = "<tu-session-token>"
```

Al igual que en Bash, estas variables solo viven en la sesión actual de
PowerShell.

## 2. Validar que las credenciales quedaron seteadas

### Ver las variables de entorno

Git Bash:

```bash
echo "$AWS_ACCESS_KEY_ID"
echo "$AWS_DEFAULT_REGION"
```

PowerShell:

```powershell
$env:AWS_ACCESS_KEY_ID
$env:AWS_DEFAULT_REGION
```

Solo para confirmar que la variable no está vacía — no hace falta imprimir
`AWS_SECRET_ACCESS_KEY` ni compartirlo con nadie.

### Validar contra AWS (la prueba real)

El AWS CLI toma las variables de entorno automáticamente (tienen prioridad
sobre `~/.aws/credentials`). Para confirmar que son válidas:

```bash
aws sts get-caller-identity
```

Mismo comando en ambas terminales. Si las credenciales son correctas,
devuelve algo como:

```json
{
    "UserId": "AIDAEXAMPLE123456",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/tu-usuario"
}
```

Si devuelve un error (`InvalidClientTokenId`, `SignatureDoesNotMatch`,
`ExpiredToken`, etc.), revisar:

- Que las variables no tengan espacios extra o comillas mal cerradas.
- Que el archivo `.env.credentials` tenga los valores correctos (sin
  placeholders tipo `your-access-key-id`).
- Que `AWS_SESSION_TOKEN` esté seteado si estás usando credenciales
  temporales.

## Orden de precedencia (por qué puede "no tomar" el cambio)

El AWS CLI resuelve credenciales en este orden (de mayor a menor prioridad):

1. Variables de entorno (`AWS_ACCESS_KEY_ID`, etc.)
2. Perfil de `~/.aws/credentials` (seteado con `aws configure`)
3. Rol de IAM asociado a la instancia/contenedor (si aplica)

Si ya corriste `aws configure` antes y ahora seteás variables de entorno,
estas últimas tienen prioridad — no hace falta borrar el perfil anterior.

## Siguiente paso

Con las credenciales validadas, continuar con
[lab1-s3-cli.md](lab1-s3-cli.md) para crear el bucket, subir un archivo y
listar objetos.
