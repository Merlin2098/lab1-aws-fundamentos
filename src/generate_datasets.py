"""Lab 0 - genera datasets de prueba (ventas, compras, movimientos bancarios).

Crea 3 archivos CSV en data/ para usarlos como archivos de prueba al subirlos
a S3 con el AWS CLI o los scripts de src/upload_and_list.*.

Uso:
    python src/generate_datasets.py
    python src/generate_datasets.py --rows 500 --output-dir data --seed 42
"""

from __future__ import annotations

import argparse
from pathlib import Path

import numpy as np
import pandas as pd

DEFAULT_ROWS = 200
DEFAULT_SEED = 42


def generate_ventas(rng: np.random.Generator, rows: int) -> pd.DataFrame:
    fechas = pd.date_range("2026-01-01", periods=180, freq="D")
    productos = ["Laptop", "Mouse", "Teclado", "Monitor", "Auriculares", "Webcam"]
    canales = ["online", "tienda", "telefono"]

    cantidad = rng.integers(1, 10, size=rows)
    precio_unitario = rng.choice([15.0, 25.5, 89.9, 150.0, 320.0, 899.0], size=rows)

    return pd.DataFrame(
        {
            "venta_id": np.arange(1, rows + 1),
            "fecha": rng.choice(fechas, size=rows),
            "producto": rng.choice(productos, size=rows),
            "canal": rng.choice(canales, size=rows),
            "cantidad": cantidad,
            "precio_unitario": precio_unitario,
            "total": cantidad * precio_unitario,
        }
    ).sort_values("fecha").reset_index(drop=True)


def generate_compras(rng: np.random.Generator, rows: int) -> pd.DataFrame:
    fechas = pd.date_range("2026-01-01", periods=180, freq="D")
    proveedores = ["Proveedor A", "Proveedor B", "Proveedor C", "Proveedor D"]
    categorias = ["insumos", "equipo", "oficina", "logistica"]
    estados = ["pendiente", "pagada", "cancelada"]

    cantidad = rng.integers(1, 50, size=rows)
    costo_unitario = rng.uniform(5.0, 500.0, size=rows).round(2)

    return pd.DataFrame(
        {
            "compra_id": np.arange(1, rows + 1),
            "fecha": rng.choice(fechas, size=rows),
            "proveedor": rng.choice(proveedores, size=rows),
            "categoria": rng.choice(categorias, size=rows),
            "cantidad": cantidad,
            "costo_unitario": costo_unitario,
            "total": (cantidad * costo_unitario).round(2),
            "estado": rng.choice(estados, size=rows, p=[0.2, 0.7, 0.1]),
        }
    ).sort_values("fecha").reset_index(drop=True)


def generate_movimientos_bancarios(rng: np.random.Generator, rows: int) -> pd.DataFrame:
    fechas = pd.date_range("2026-01-01", periods=180, freq="D")
    tipos = ["deposito", "retiro", "transferencia", "pago_servicio"]
    cuentas = ["CTA-001", "CTA-002", "CTA-003"]

    tipo = rng.choice(tipos, size=rows)
    monto = rng.uniform(10.0, 5000.0, size=rows).round(2)
    # Retiros y pagos de servicio restan saldo.
    signo = np.where(np.isin(tipo, ["retiro", "pago_servicio"]), -1, 1)

    return pd.DataFrame(
        {
            "movimiento_id": np.arange(1, rows + 1),
            "fecha": rng.choice(fechas, size=rows),
            "cuenta": rng.choice(cuentas, size=rows),
            "tipo": tipo,
            "monto": (monto * signo).round(2),
            "descripcion": [f"Movimiento {t}" for t in tipo],
        }
    ).sort_values("fecha").reset_index(drop=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rows", type=int, default=DEFAULT_ROWS, help="Filas por dataset (default: %(default)s)")
    parser.add_argument("--output-dir", type=Path, default=Path("data"), help="Carpeta de salida (default: %(default)s)")
    parser.add_argument("--seed", type=int, default=DEFAULT_SEED, help="Seed para reproducibilidad (default: %(default)s)")
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(args.seed)

    datasets = {
        "ventas.csv": generate_ventas(rng, args.rows),
        "compras.csv": generate_compras(rng, args.rows),
        "movimientos_bancarios.csv": generate_movimientos_bancarios(rng, args.rows),
    }

    for filename, df in datasets.items():
        out_path = args.output_dir / filename
        df.to_csv(out_path, index=False)
        print(f"Generado: {out_path} ({len(df)} filas)")


if __name__ == "__main__":
    main()
