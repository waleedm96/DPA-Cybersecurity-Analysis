# SENTINEL - Part 1: Volume

We use PySpark to study network traffic with CSE-CIC-IDS2018 and the IANA service and port registry.

## Research questions

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

## What we have done

The code is in [DPA_Volume_Part1.ipynb](notebooks/DPA_Volume_Part1.ipynb).

1. Check the headers and small traffic samples, and inspect IANA.
2. Define explicit schemas for both datasets.
3. Test CSV reading and Parquet saving with 5,000 traffic rows and the whole IANA file.
4. Read all ten original traffic files, save typed Parquet, clean both datasets, and record the row counts.

Each cleaning step has a reason before its code. We keep the source CSVs unchanged.

Part 1 uses `data/CSECICIDS2018_original/`. Nine files have 80 columns and 20 February has 84. We use the matching schema for each file. The extra fields are null where a source file does not have them. The improved release is saved separately for later work.

## Run the notebook

Start Docker Desktop. From this project folder, run:

```powershell
docker compose up -d
```

Open <http://127.0.0.1:8888/lab> with token `dpa-local-token-change-me`.
Open the notebook and run the cells from top to bottom. Keep `DOWNLOAD_DATA = False` if the data is already there.

You can also use your own Jupyter environment with PySpark and Java. Step 1 uses Python only.

To stop Docker:

```powershell
docker compose down
```

## Data and results

See [data/README.md](data/README.md) for download instructions and source links.

| Folder | What it contains |
| --- | --- |
| `data/CSECICIDS2018_original/` | Original traffic CSVs used in Part 1 |
| `data/Service and port name/` | IANA CSV |
| `data/CSECICIDS2018_improved/` | Improved release for later work |
| `data/intermediate/original/` | Small traffic samples |
| `data/parquet/original/sample/` | Parquet tables for the sample test |
| `data/parquet/original/raw/` | All source data as typed Parquet |
| `data/parquet/original/cleaned/` | Cleaned traffic and IANA tables |
| `reports/inspection/original/` | Header checks and inspection summary |
| `reports/cleaning/original/cleaning_audit.csv` | Row counts and reasons for each cleaning step |

Next: IANA enrichment, research analysis and charts, then CSV and Parquet timing comparisons.
