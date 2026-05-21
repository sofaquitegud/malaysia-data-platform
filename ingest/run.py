"""
Extract-Load job: parquet -> BigQuery

Run with:  uv run python -m ingest.run
Auth: Application Default Credentials (gcloud auth application-default login)
Idempotent: WRITE_TRUNCATE rebuilds each table on every run
"""

import pandas as pd
from google.cloud import bigquery

from ingest.sources import SOURCES

PROJECT_ID = "malaysia-open-data-syafiq"
DATASET_ID = "raw_malaysia"


def main() -> None:
    client = bigquery.Client(project=PROJECT_ID)
    client.create_dataset(
        bigquery.DatasetReference(PROJECT_ID, DATASET_ID), exists_ok=True
    )
    
    for cfg in SOURCES:
        df = pd.read_parquet(cfg["parquet_url"])
        df["_ingested_at"] = pd.Timestamp.now(tz="UTC")

        table_ref = f"{PROJECT_ID}.{DATASET_ID}.{cfg['name']}"
        job = client.load_table_from_dataframe(
            df,
            table_ref,
            job_config=bigquery.LoadJobConfig(
                write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,
                autodetect=True
            )
        )
        job.result()
        table = client.get_table(table_ref)
        print(f"loaded {table.num_rows:,} rows -> {table_ref}")


if __name__ == "__main__":
    main()
