# Malaysia Data Platform

End-to-end analytics platform on Malaysian open data ([data.gov.my](https://data.gov.my)):
**ingestion (dlt) → BigQuery → dbt (staging/marts + tests/docs) → CI → Looker Studio.**

Theme: *Malaysia Cost of Living & Mobility* — fuel prices vs. inflation vs. transport ridership.

## Stack
- **EL:** Python + [dlt](https://dlthub.com) reading data.gov.my parquet files
- **Warehouse:** BigQuery (sandbox, free tier)
- **Transform:** dbt (coming in Phase 2)
- **BI:** Looker Studio (coming in Phase 5)

## Setup
```bash
uv sync                                   # install deps
gcloud auth application-default login     # local BigQuery auth
uv run python -m ingest.run               # land raw data
```

## Data source
All data © data.gov.my, used under their open data terms.

---

## 4. BigQuery auth (local)

dlt uses **Application Default Credentials** when you give it only a `project_id`. So no service-account key file on your laptop (you'll add one only for CI in Phase 4):

```bash
gcloud auth application-default login
gcloud config set project malaysia-open-data
