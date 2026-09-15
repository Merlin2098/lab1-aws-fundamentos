# Lab 1 — Cómo ejecutar los scripts (Git Bash / PowerShell)

Guía rápida para correr `src/upload_and_list.sh` y `src/upload_and_list.ps1`
sin pelearte con la sintaxis de la terminal. Elegí la sección según qué
terminal estés usando.

Ambos scripts hacen exactamente lo mismo: verifican tu identidad AWS, crean
el bucket si no existe, suben los tres datasets de `data/` y listan el
contenido del bucket.

## Git Bash

### Uso

```bash
bash src/upload_and_list.sh <nombre-bucket> [region]
```

Ejemplo:

```bash
bash src/upload_and_list.sh bootcamp-da-rfuculmana us-east-1
```

Si omitís la región, usa `us-east-1` por defecto:

```bash
bash src/upload_and_list.sh bootcamp-da-rfuculmana
```

### Alternativa: ejecutarlo como `./upload_and_list.sh`

También podés invocarlo directamente (sin anteponer `bash`) si el archivo
tiene permiso de ejecución:

```bash
cd src
chmod +x upload_and_list.sh
./upload_and_list.sh <nombre-bucket>
```

Con `bash src/upload_and_list.sh ...` (primera opción) no hace falta
`chmod`, así que es la forma más simple si no querés pensar en permisos.

### Errores comunes

- **`Uso: src/upload_and_list.sh bootcamp-da-rfuculmana [region]`** — te
  olvidaste de pasar el nombre del bucket como argumento. El primer
  parámetro es obligatorio.
- **`Permission denied`** al usar `./upload_and_list.sh` — falta el permiso
  de ejecución, corré `chmod +x upload_and_list.sh` o usá `bash
  upload_and_list.sh ...` en su lugar.
- **`command not found: aws`** — el AWS CLI no está en el `PATH` de Git
  Bash. Verificá con `aws --version`; si falla, reinstalá el AWS CLI o
  abrí una terminal nueva.

## PowerShell

### Uso

```powershell
.\src\upload_and_list.ps1 -BucketName <nombre-bucket> [-Region <region>]
```

Ejemplo:

```powershell
.\src\upload_and_list.ps1 -BucketName bootcamp-da-rfuculmana -Region us-east-1
```

Si omitís `-Region`, usa `us-east-1` por defecto:

```powershell
.\src\upload_and_list.ps1 -BucketName bootcamp-da-rfuculmana
```

### Errores comunes

- **`No se puede cargar el archivo ... porque la ejecución de scripts está
  deshabilitada en este sistema`** — la política de ejecución de PowerShell
  bloquea scripts locales. Solucionalo para la sesión actual (no requiere
  privilegios de administrador ni cambia nada de forma permanente):

  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  ```

  Después corré el script normalmente. Esto solo aplica a la ventana de
  PowerShell abierta; al cerrarla, la política vuelve a su valor anterior.

- **`El término '.\src\upload_and_list.ps1' no se reconoce...`** — te falta
  el `.\` antes del nombre del script (PowerShell no busca en el directorio
  actual por defecto), o no estás parado en la raíz del repo. Verificá con
  `pwd`/`Get-Location` que estés en la carpeta del proyecto.

- **`No se puede enlazar el parámetro 'BucketName'...`** — te olvidaste de
  pasar `-BucketName <nombre>`. A diferencia del script de bash, en
  PowerShell los parámetros van con nombre explícito (`-BucketName`,
  `-Region`), no por posición.

## ¿Cuál uso?

- **Git Bash**: si abrís la terminal como "Git Bash" (viene con Git para
  Windows) o estás en macOS/Linux.
- **PowerShell**: si abrís "PowerShell" o "Windows PowerShell" desde el
  menú de Windows o la terminal integrada de VS Code en modo PowerShell.

Ambos scripts requieren tener las credenciales de AWS ya configuradas — ver
[lab1-aws-credentials.md](lab1-aws-credentials.md) — y los datasets
generados con `python src/generate_datasets.py` (ver el
[README](../README.md) para el flujo completo paso a paso).
