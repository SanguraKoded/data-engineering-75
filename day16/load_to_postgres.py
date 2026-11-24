import csv
import ast
import os
from pathlib import Path

import psycopg2
from psycopg2.extras import Json

# Locate the CSV in the project root
PROJECT_DIR = Path(__file__).resolve().parent.parent
CSV_FILE = PROJECT_DIR / "weather_data.csv"

# PostgreSQL connection settings
DB_CONFIG = {
    "host": "localhost",
    "port": 5432,
    "database": "weather_dw",
    "user": "postgres",
    "password": os.getenv("PGPASSWORD")
}

JSON_COLUMNS = {"coord", "weather", "main", "wind", "clouds", "sys", "rain"}

def parse_json_column(value):
    """Convert Python-style dictionary/list strings into JSONB values."""
    if not value or not value.strip():
        return None
    parsed_value = ast.literal_eval(value)
    return Json(parsed_value)


def load_weather_data():
    if not DB_CONFIG["password"]:
        raise ValueError("Set the PGPASSWORD environment variable first.")

    if not CSV_FILE.exists():
        raise FileNotFoundError(f"CSV file not found: {CSV_FILE}")

    conn = None

    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        conn = psycopg2.connect(**DB_CONFIG)
        cursor = conn.cursor()

        # Create the table if it doesn't exist in weather_dw
        cursor.execute("""
            CREATE TABLE IF NOT EXISTS weather_raw (
                record_id BIGSERIAL PRIMARY KEY,
                coord JSONB,
                weather JSONB,
                base TEXT,
                main JSONB,
                visibility INTEGER,
                wind JSONB,
                clouds JSONB,
                dt BIGINT,
                sys JSONB,
                timezone INTEGER,
                city_id BIGINT,
                name VARCHAR(100),
                cod INTEGER,
                rain JSONB,
                temperature DOUBLE PRECISION,
                humidity INTEGER,
                temp_category VARCHAR(50),
                loaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            );
        """)
        conn.commit()

        with open(CSV_FILE, "r", encoding="utf-8", newline="") as file:
            # FIX 1: Use tab delimiter
            reader = csv.DictReader(file, delimiter="\t")

            required_columns = {
                "coord", "weather", "base", "main",
                "visibility", "wind", "clouds", "dt",
                "sys", "timezone", "id", "name",
                "cod", "rain", "temperature",
                "humidity", "temp_category"
            }

            if not required_columns.issubset(reader.fieldnames or []):
                raise ValueError(
                    f"Missing CSV columns: "
                    f"{required_columns - set(reader.fieldnames or [])}"
                )

            rows = []

            for row in reader:
                # FIX 2: Explicitly map values in the exact order of the SQL INSERT
                values = (
                    parse_json_column(row.get("coord")),
                    parse_json_column(row.get("weather")),
                    row.get("base"),
                    parse_json_column(row.get("main")),
                    int(row.get("visibility")) if row.get("visibility") else None,
                    parse_json_column(row.get("wind")),
                    parse_json_column(row.get("clouds")),
                    int(row.get("dt")) if row.get("dt") else None,
                    parse_json_column(row.get("sys")),
                    int(row.get("timezone")) if row.get("timezone") else None,
                    int(row.get("id")) if row.get("id") else None,       # maps to city_id
                    row.get("name"),
                    int(row.get("cod")) if row.get("cod") else None,
                    parse_json_column(row.get("rain")),
                    float(row.get("temperature")) if row.get("temperature") else None,
                    int(row.get("humidity")) if row.get("humidity") else None,
                    row.get("temp_category")
                )
                rows.append(values)

        insert_query = """
            INSERT INTO weather_raw (
                coord, weather, base, main, visibility,
                wind, clouds, dt, sys, timezone, city_id,
                name, cod, rain, temperature, humidity,
                temp_category
            )
            VALUES (
                %s, %s, %s, %s, %s, %s, %s, %s, %s,
                %s, %s, %s, %s, %s, %s, %s, %s
            )
        """

        cursor.executemany(insert_query, rows)
        conn.commit()

        print(f"Successfully loaded {len(rows)} weather records.")
        cursor.close()

    except Exception as error:
        if conn:
            conn.rollback()
        print("Data loading failed:", error)

    finally:
        if conn:
            conn.close()


if __name__ == "__main__":
    load_weather_data()