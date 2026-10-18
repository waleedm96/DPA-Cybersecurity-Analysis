# DPA - Network Traffic Analysis

We use PySpark to clean CSE-CIC-IDS2018 traffic, join it with IANA service names, and answer:

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

## Run the project

1. Install and start Docker Desktop.
2. Open a terminal in this folder, beside `docker-compose.yml`.
3. Run:

   ```powershell
   docker compose up --build -d
   ```

4. Open <http://127.0.0.1:8888/lab?token=sentinel-local>.
5. Open `notebooks/DPA_Volume_Part1.ipynb`.
6. Choose **Restart Kernel and Run All Cells**.

For a quick evaluation without downloading data, set:

```python
USE_SUBSET = True
DOWNLOAD_DATA = False
```

This uses the included CSVs: about one million uncleaned traffic records and the full IANA file. No download is needed.

Spark settings are in `config/spark-defaults.conf`: two CPU cores, 4 GB driver memory, 64 MB file partitions and 48 shuffle partitions. This leaves room for Python and file reads when Docker has about 8 GB available. Restart the kernel after changing these settings. `.env.example` contains optional Jupyter settings; the defaults work without creating a `.env` file.

To check the installation, run `docker compose exec jupyter python scripts/test_spark.py`. This checks Spark, SQL and Parquet; run the notebook to check the complete analysis.

## Run the full dataset

In the first code cell, set `USE_SUBSET = False`. Set `DOWNLOAD_DATA = True` if the original files are not downloaded yet. The traffic CSVs need about 7 GB, plus space for Parquet and Spark temporary files.

After changing the settings, restart the kernel and run all cells.

After changing the Docker setup, save the notebook and run `docker compose up --build -d --force-recreate` from this folder. Reopen Jupyter and restart the kernel before running the notebook again. The notebook prints the Spark version; this Docker setup uses Spark 4.2.0.

## What the notebook does

Check files, define schemas, test reading, clean both datasets, join IANA service names, then calculate and plot the results. Each cleaning step explains its reason and prints the rows removed or changed. Original CSVs stay unchanged.

Results are saved in `reports/subset/` for subset mode and `reports/` for full mode: `cleaning/original/` has the cleaning log, `analysis/` has result tables, and `charts/` has the figures. Parquet tables are saved in `data/parquet/`.

Use the subset to check the project quickly. It includes extra rare labels and dirty records, so use the full dataset for final research findings. See [data/README.md](data/README.md) for sources and folders.

To stop Jupyter, run `docker compose down`.
