# DPA Cybersecurity — Volume Part 1 project (based on your Spark SQL TP)

This project expands the original Spark starter with an annotated Jupyter notebook **`notebooks/DPA_Volume_Part1.ipynb`**, and a tiny **synthetic** CSV dataset so you can test the whole ingestion→cleaning→join→analysis flow without downloading 30 GB first.

## Setup / how to open

1. Install Docker Desktop (WSL 2 backend) and VS Code on Windows.
2. Extract this ZIP to `C:\DPA-Volume-Part1-Project` (or any folder).
3. In VS Code, open that folder and execute `docker compose up -d` from its terminal.
4. Test Spark first with `docker compose exec spark python /home/jovyan/work/scripts/test_spark.py`.
5. Open `http://127.0.0.1:8888/lab` and use token `dpa-local-token-change-me` (change for security if desired).
6. In JupyterLab open `notebooks/DPA_Volume_Part1.ipynb` and run cells in order with `DEMO_MODE=True`.
7. For real data, copy the *extracted* Improved CSE-CIC-IDS2018 CSVs to `data/raw/cse-cic-ids2018/` (subfolders are okay), and the official IANA CSV to `data/raw/iana/service-names-port-numbers.csv`. Change `DEMO_MODE = False`, then rerun cells in order.
8. Output: `data/parquet/demo|real/` and `reports/demo|real/cleaning_audit.csv`.
9. Shutdown with `docker compose down`.

## What the notebook implements

- Ingestion with **explicit Spark schemas**, no `inferSchema=True`, then typed Parquet.
- Data cleaning: modified-label counts, missing fields, exact duplicates, invalid ports/duration, invalid dates, and justified drop/flag policies, with before/after row counts.
- IANA join on destination port **and** protocol, de-duplicating registry join keys to prevent multiplying flows.
- DataFrame API and Spark SQL: benign/attempted/attack rates, labels, ports/services, dates, mean duration/packet counts, and optional source IP analysis.
- Spark SQL query plan examination with `.explain("formatted")`.

## Important caveats

- Synthetic demo flows are invented for functional testing and **must not** be represented as real research results.
- Real dataset column headers and timestamps must be inspected before trusting results. Any unrecognized header is explicitly loaded as StringType and printed as `REVIEW explicit types` — update the map if necessary.
- For the real CSVs, each file's header is used to assemble a typed Spark schema, and files are unioned by name to tolerate day-to-day column differences.
- Spark ingestion may turn invalid text in numeric columns into null. Critical missing fields are filtered and quantified, while extreme attack-related values are flagged, not automatically discarded.
- Dataset size is ~30 GB uncompressed; do not use pandas to read the entire dataset. The notebook uses Spark batch DataFrames.
- Do not put credentials or private data inside the project notebook.
- On a laptop with 16 GB RAM, start in demo mode, then run just a few real CSV files before the entire archive.
- Docker Compose uses the same base image as the earlier Spark starter. Spark, Python, and Java run inside that container, not directly on Windows.

## Original teaching material

The code is adapted from your uploaded `spark-sql-tp.ipynb` notebook, retaining techniques for Spark sessions, explicit schema, `select`, `withColumn`, filtering, distinct rows, grouping, aggregations, SQL views, datetime functions, Parquet and query plans. The original teacher notebook is not altered.

Dataset references:
- Improved CSE-CIC-IDS2018: https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html
- IANA Port Registry: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv

---

# DPA Cybersecurity — Spark starter environment

## What is included?

- Docker Compose setup for an official Jupyter PySpark image, pinned to the `c9ecde976a5f` build.
- Python, Java, Apache Spark, PySpark, Spark SQL and JupyterLab *inside the Docker container*.
- A tiny Spark smoke test with an explicit schema, a Spark SQL query, Parquet write, and read-back.
- Folders for the two datasets, notebooks, reports and Parquet tables.

## Prerequisites (Windows)

1. Install WSL 2 with administrator PowerShell command `wsl --install` (restart if asked).
2. Install and open Docker Desktop using WSL 2/Linux containers.
3. Install Visual Studio Code (recommended).
4. Ensure Docker Desktop is running.

## Getting started

1. Extract this ZIP to a short path, e.g. `C:\DPA-Cybersecurity-Starter`.
2. Open the extracted project folder in VS Code.
3. Open VS Code > Terminal > New Terminal (PowerShell).
4. Run `docker --version` and `docker compose version`.
5. Run `docker compose up -d` from the folder containing `docker-compose.yml`.
   The first image download is **several gigabytes**, so it may take some time.
6. Run `docker compose ps` and confirm the `spark` container is running.
7. Run the installation test:
   `docker compose exec spark python /home/jovyan/work/scripts/test_spark.py`
8. You should see: `SUCCESS: Spark, SQL, schema, Parquet write, and Parquet read are working!`
9. Open `http://127.0.0.1:8888/lab` in your browser.
   Enter token: `dpa-local-token-change-me` (change it in docker-compose.yml if desired).
10. Stop the environment with `docker compose down` (your project files are preserved).

## Project data locations

Copy *extracted* Improved CSE-CIC-IDS2018 CSV files to:
`data/raw/cse-cic-ids2018/`

Copy the official IANA CSV to:
`data/raw/iana/service-names-port-numbers.csv`

Do **not** load the full 30 GB dataset until the smoke test passes. For the actual Part 1 work, begin with a small sample; read source CSV with an explicit Spark schema; write typed Parquet (bronze); clean while logging affected rows; then write cleaned Parquet and analyze via Spark SQL.

## Important details

- The container is limited to **8 GiB RAM** and **2 CPUs**, suitable as a conservative starting point on a 16 GB laptop. Adjust later after measuring memory usage.
- Jupyter port 8888 and Spark UI port 4040 are bound to **localhost only**.
- No separate Java or Python installation on Windows is needed for *containerized* Spark execution.
- The initial image is relatively large. Keep adequate free disk space.
- Because the project directory is bind-mounted, notebooks, scripts and Parquet files created inside `/home/jovyan/work` persist on Windows.
- Spark UI is accessible at `http://127.0.0.1:4040` only while an active Spark context runs.

## Troubleshooting

- `docker: command not found` / `not recognized`: install or restart Docker Desktop, and restart VS Code/PowerShell.
- `Cannot connect to the Docker daemon`: open Docker Desktop and wait for it to report the engine is running.
- Port 8888 already in use: change the LEFT 8888 in `docker-compose.yml` to e.g. 8889, then open `http://127.0.0.1:8889/lab`.
- Failed image download: check internet connection and available disk space, then retry `docker compose up -d`.
- Restart with `docker compose down` followed by `docker compose up -d`.
