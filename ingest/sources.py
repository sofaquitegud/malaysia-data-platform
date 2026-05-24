SOURCES = [
    {
        "name": "fuelprice", # raw_malaysia.fuelprice table
        "parquet_url": "https://storage.data.gov.my/commodities/fuelprice.parquet",
        "write_disposition": "replace" # full refresh
    },
    {
        "name": "cpi_2d", # raw_malaysia.cpi_2d table
        "parquet_url": "https://storage.dosm.gov.my/cpi/cpi_2d.parquet",
        "write_disposition": "replace"
    }
]
