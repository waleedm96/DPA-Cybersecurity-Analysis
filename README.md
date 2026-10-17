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
5. Join the cleaned traffic with IANA by destination port and protocol, keeping all traffic rows.
6. Compare normal traffic and attacks, examine each label, and find its top ports and services.

Each cleaning step has a reason before its code. We keep the source CSVs unchanged.

Part 1 uses `data/Dataset Network Traffic/`. Nine files have 80 columns and 20 February has 84. We use the matching schema for each file. The extra fields are null where a source file does not have them. The improved release is saved separately for later work.

## Run the notebook

Start Docker Desktop. From this project folder, run:

```powershell
docker compose up -d
```

Open <http://127.0.0.1:8888/lab> with token `sentinel-local`.
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
| `data/Dataset Network Traffic/` | Original traffic CSVs used in Part 1 |
| `data/Dataset Service and Port/` | IANA CSV |
| `data/Dataset Network Traffic improved/` | Improved release for later work |
| `data/samples/` | Small traffic samples |
| `data/parquet/sample/` | Parquet tables for the sample test |
| `data/parquet/raw/` | All source data as typed Parquet |
| `data/parquet/cleaned/` | Cleaned traffic and IANA tables |
| `data/parquet/enriched/traffic/` | Traffic with IANA service names |
| `reports/inspection/original/` | Header checks and inspection summary |
| `reports/cleaning/original/cleaning_audit.csv` | Row counts and reasons for each cleaning step |
| `reports/analysis/` | Small research-result tables saved as CSV |

Step 5 checks that the join keeps the same row count and prints matched and unmatched traffic counts. A service name is a registered port association, not proof of the application.

The notebook uses `raw_traffic` for the typed input, `traffic` while cleaning, and `final_traffic` for the saved table with service names.

Step 6 explains which research question each comparison answers. It compares averages and medians, shows the middle 50% of flow durations, and lists service coverage and top ports for each label. These are patterns in this dataset, not a tested attack detector.

Next: charts, CSV and Parquet timing comparisons, and the final report.
