SOURCES = [
    {
        "name": "fuelprice", # raw_malaysia.fuelprice table
        "parquet_url": "https://storage.data.gov.my/commodities/fuelprice.parquet",
        "write_disposition": "replace" # full refresh
    }
]
