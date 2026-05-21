"""Extract-Load job: parquet -> BigQuery

Run with:  uv run python -m ingest.run
Idempotent: write_disposition="replace" rebuilds each table on every run
"""

import dlt
import pandas as pd

from ingest.sources import SOURCES


def make_resource(cfg: dict):
    """Build a dlt resource that streams one parquet file."""

    @dlt.resource(name=cfg["name"], write_disposition=cfg["write_disposition"])
    def _resource():
        df = pd.read_parquet(cfg["parquet_url"])
        df["_ingested_at"] = pd.Timestamp.now(tz="UTC")
        yield df.to_dict("records")

    return _resource


def main() -> None:
    pipeline = dlt.pipeline(
        pipeline_name="malaysia_open_data",
        destination="bigquery",
        dataset_name="raw_malaysia",
    )
    for cfg in SOURCES:
        info = pipeline.run(make_resource(cfg)())
        print(info)


if __name__ == "__main__":
    main()
