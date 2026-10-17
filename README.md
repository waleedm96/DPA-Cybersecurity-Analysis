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

Each cleaning step has a reason before its code. We keep the source CSVs unchanged.

Part 1 uses `data/Dataset Network Traffic/`. Nine files have 80 columns and 20 February has 84. We use the matching schema for each file. The extra fields are null where a source file does not have them. The improved release is saved separately for later work.

## Run the notebook

Start Docker Desktop. From this project folder, run:

```powershell
docker compose up -d --build
```

Open <http://127.0.0.1:8888/lab> with token `sentinel-local`.
Open the notebook and run the cells from top to bottom. Keep `DOWNLOAD_DATA = False` if the data is already there.

Compose provides working defaults; optionally copy `.env.example` to `.env` and customize the Jupyter token. The project is mounted at `/home/jovyan/Dpa-Cybersecurity-Analysis`.

Spark reads `config/spark-defaults.conf` through the container's `SPARK_CONF_DIR`. This file controls the local workers, 6 GB driver heap, and 48 shuffle partitions. Allocate enough RAM to Docker Desktop for the heap plus Python, Java overhead, and Jupyter. `shm_size` is not the container's RAM allocation. Restart the notebook kernel after changing Spark startup settings. Notebook startup uses these shared defaults.

Verify the environment independently of the downloaded datasets:

```powershell
docker compose exec -T jupyter python scripts/test_spark.py
```

The smoke test checks configuration loading, Spark SQL, and a Parquet round trip using four synthetic records. It writes only `data/parquet/installation_test/`. The image pins Spark 3.5.0 and the plotting dependencies; do not install a second PySpark version over the bundled Spark distribution.

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

Step 5 checks that the join keeps the same row count and prints matched and unmatched traffic counts. A service name is a registered port association, not proof of the application.

The notebook uses `raw_traffic` for the typed input, `traffic` while cleaning, and `final_traffic` for the saved table with service names.

Next: research analysis and charts, then CSV and Parquet timing comparisons.
