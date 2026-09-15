# Lab 1 — AWS Fundamentos

Primer laboratorio del bootcamp de Data Analytics. El objetivo es que cada
alumno se familiarice con el **AWS CLI** haciendo tres cosas sobre un bucket
de S3: configurar credenciales, subir archivos y listar el contenido del
bucket — tanto escribiendo los comandos a mano como usando scripts.

No se necesita experiencia previa con AWS. Sí se asume que ya tenés el AWS
CLI instalado y un usuario IAM con acceso a S3 (credenciales entregadas por
el instructor).

## ¿Qué vas a aprender?

- Cómo autenticarte contra AWS desde la terminal, de dos formas distintas
  (perfil persistente vs. variables de entorno).
- Los comandos básicos de S3: crear un bucket, subir un archivo (`cp`) y
  listar objetos (`ls`).
- La diferencia entre ejecutar esos comandos "a mano" y automatizarlos con
  un script (bash o PowerShell).
- Cómo generar datasets de prueba en Python para tener algo real que subir.

## Cómo empezar

Cloná el repositorio y entrá a la carpeta del proyecto:

```bash
git clone https://github.com/Merlin2098/lab1-aws-fundamentos.git
cd lab1-aws-fundamentos
```

## Mapa del proyecto

```
lab0/
├── README.md                          <- estás acá
├── docs/
│   ├── lab1-aws-credentials.md        <- cómo configurar y validar credenciales
│   ├── lab1-s3-cli.md                 <- comandos AWS CLI para S3 (crear bucket, subir, listar)
│   └── lab1-ejecutar-scripts.md       <- cómo correr los scripts en Git Bash y PowerShell
├── src/
│   ├── generate_datasets.py           <- genera los CSV de prueba en data/
│   ├── upload_and_list.sh             <- script bash: crea bucket + sube + lista
│   └── upload_and_list.ps1            <- mismo script en PowerShell
└── data/
    ├── ventas.csv                     <- dataset de prueba generado
    ├── compras.csv                    <- dataset de prueba generado
    └── movimientos_bancarios.csv      <- dataset de prueba generado
```

> Nota: el nombre de la carpeta local (`lab0`) puede no coincidir con el
> nombre del proyecto/repositorio (`lab1-aws-fundamentos`) — no afecta nada
> de lo que hacés en este laboratorio.

## Ruta sugerida (paso a paso)

Seguí los pasos en este orden — cada uno depende del anterior:

### 1. Generá los datasets de prueba

Antes de subir nada a S3, necesitás archivos. Corré:

```bash
python src/generate_datasets.py
```

Esto crea `data/ventas.csv`, `data/compras.csv` y
`data/movimientos_bancarios.csv` con datos sintéticos. Podés ajustar la
cantidad de filas con `--rows` (ver el docstring del script para más
opciones).

### 2. Configurá tus credenciales de AWS

Leé **[docs/lab1-aws-credentials.md](docs/lab1-aws-credentials.md)**. Ahí
se explican dos caminos — elegí el que te resulte más cómodo:

- **`aws configure`**: guarda un perfil persistente en tu máquina. Simple,
  lo hacés una sola vez.
- **Variables de entorno** desde un archivo `.env.credentials`: no persiste
  nada en disco fuera del proyecto, útil si preferís no tocar
  `~/.aws/credentials`.

El doc también explica cómo **validar** que las credenciales quedaron bien
configuradas, en PowerShell y en Git Bash.

### 3. Subí archivos y listá el bucket

Con las credenciales listas, seguí **[docs/lab1-s3-cli.md](docs/lab1-s3-cli.md)**
para:

1. Crear tu propio bucket (el nombre debe ser único a nivel global en AWS).
2. Subir uno de los CSV generados en el paso 1.
3. Listar el contenido del bucket para confirmar que la subida funcionó.

Ese documento trae los comandos exactos con ejemplos, más una tabla resumen
al final.

### 4. (Opcional) Automatizá todo con un script

Si ya entendiste los comandos manuales y querés repetir el flujo rápido,
usá uno de los scripts en `src/` — hacen lo mismo que el paso 3 pero en un
solo comando (crean el bucket si no existe, suben archivo(s) y listan el
resultado). El único dato que tenés que editar es el nombre del bucket.

Ver **[docs/lab1-ejecutar-scripts.md](docs/lab1-ejecutar-scripts.md)** para
la sintaxis exacta y los errores más comunes (permisos, política de
ejecución de PowerShell, etc.). Resumen rápido:

```bash
# Git Bash — sube automáticamente los 3 datasets de data/
./src/upload_and_list.sh <nombre-bucket>
```

```powershell
# PowerShell — sube automáticamente los 3 datasets de data/
.\src\upload_and_list.ps1 -BucketName <nombre-bucket>
```

## ¿Por dónde empiezo si me trabo?

- **"No sé si mis credenciales están bien configuradas"** → sección de
  validación en
  [docs/lab1-aws-credentials.md](docs/lab1-aws-credentials.md).
- **"El nombre de mi bucket ya existe"** → los nombres de bucket son
  globales en todo AWS, no solo en tu cuenta; probá con un nombre más
  específico (usuario + fecha, por ejemplo).
- **"No tengo archivos para subir"** → corré
  `python src/generate_datasets.py` (paso 1).
- **"¿Qué comando hace X?"** → tabla resumen al final de
  [docs/lab1-s3-cli.md](docs/lab1-s3-cli.md).
