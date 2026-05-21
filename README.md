# Malaysia Data Platform

End-to-end analytics platform on Malaysian open data ([data.gov.my](https://data.gov.my)).

**Theme:** *Malaysia Cost of Living & Mobility* — tracking fuel prices, inflation, and
public-transport ridership over time to answer: how has the cost of mobility changed for
Malaysians?

## Architecture

```
data.gov.my              Python                  BigQuery (sandbox)         dbt                  Looker Studio
┌─────────────┐  parquet ┌──────────────┐  load  ┌───────────────┐  query ┌───────────────┐  viz ┌──────────┐
│ data.gov.my │ ───────▶ │ ingest/run.py│ ─────▶ │ raw_malaysia  │ ─────▶ │ staging/marts │ ───▶ │ dashboard│
│ (parquet)   │          │ (idempotent) │        │ (landing zone)│        │ tests + docs  │      │          │
└─────────────┘          └──────────────┘        └───────────────┘        └───────────────┘      └──────────┘
                                                                                  │
                                                         GitHub Actions CI: dbt build + sqlfluff on every PR
```

## Stack

| Layer | Tool | Why |
|-------|------|-----|
| Extract-Load | Python + `google-cloud-bigquery` | Explicit, ADC-native, zero credential friction for local dev |
| Warehouse | BigQuery sandbox | Free (10 GB storage, 1 TB query/month); forces constraint-aware design |
| Transform | dbt-bigquery | Layered modeling, lineage, tests-as-code, CI-friendly |
| Orchestration | GitHub Actions | CI on every PR: sqlfluff lint + `dbt build` |
| BI | Looker Studio | Native BigQuery connector, free, shareable |

## Datasets (data.gov.my)

| Table | Source | Description |
|-------|--------|-------------|
| `raw_malaysia.fuelprice` | [fuelprice](https://data.gov.my/data-catalogue/fuelprice) | Weekly RON95/RON97/diesel retail prices (2017–present) |
| *(more coming)* | | CPI, transport ridership |

## Quickstart

```bash
# 1. install deps
uv sync

# 2. authenticate (two separate steps — a common gotcha)
gcloud auth login                        # authenticates gcloud CLI
gcloud auth application-default login   # sets ADC for Python libraries
gcloud config set project malaysia-open-data

# 3. land raw data
uv run python -m ingest.run
```

> **Why two auth commands?** `gcloud auth login` = CLI credentials.
> `gcloud auth application-default login` = ADC credentials that `google.auth.default()`
> (used by `bigquery.Client()`) reads. They are separate credential stores — skipping the
> second step causes `DefaultCredentialsError` even when you're logged into the CLI.

## BigQuery sandbox limits

| Limit | Value | Impact |
|-------|-------|--------|
| Storage | 10 GB free | Fine for this dataset size |
| Query | 1 TB/month free | Fine; dbt staging models are views (no storage cost) |
| Table expiry | 60 days auto-delete | Expected; document it rather than fight it |
| Scheduled queries | Not available | Why ingestion is a Python job, not a managed transfer |

## Data source

All data © [data.gov.my](https://data.gov.my), used under Malaysia's open data terms.
