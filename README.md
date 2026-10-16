# SENTINEL - Part 1: Volume

We are using PySpark to study network traffic with two datasets:
CSE-CIC-IDS2018 and the IANA service-name and port-number registry.

## Research questions

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

## Work completed

The code is in [DPA_Volume_Part1.ipynb](notebooks/DPA_Volume_Part1.ipynb).

- Optional notebook download: download the original traffic CSVs and the IANA registry.
- Step 1: compare headers, inspect small traffic samples and the IANA registry.
- Step 2: define explicit column types and check that the headers match.
- Step 3: read the traffic sample and IANA CSV with Spark, write Parquet, and verify the read-back.
- Step 4: ingest all original files, clean traffic and IANA, and save a measured cleaning audit.

Steps 1–3 use 5,000 inspected traffic records to test ingestion. Step 4 reads
all ten original CSVs, writes typed raw Parquet, and cleans the complete traffic
and IANA tables. Joins and the final research analysis remain pending.

All traffic-processing steps use `data/CSECICIDS2018_original/`.
Nine files have 80 columns; 20 February has 84. Each layout has an explicit
schema, and Spark combines them by column name. The four extra fields are
null for files that do not supply them. The improved release is kept separately
for later work.

## Run the notebook

Start Docker Desktop, then run from this folder:

```powershell
docker compose up -d
```

Open <http://127.0.0.1:8888/lab> with token `dpa-local-token-change-me`.
Open the notebook and run its cells from top to bottom. Keep
`DOWNLOAD_DATA = False` when the datasets are already present.

You can also use your own Jupyter environment. Step 1 uses ordinary Python;
Step 2 requires PySpark installed in that kernel and does not start Spark.
Step 3 also needs Java and a working Spark runtime.

## Data and outputs

- `data/CSECICIDS2018_original/`: the 10 original traffic CSVs used for Part 1.
- `data/CSECICIDS2018_improved/`: the improved traffic release, kept for later work.
- `data/Service and port name/`: the IANA CSV; the existing `(3).csv` filename is accepted.
- `reports/inspection/original/`: the original-data inspection summary and header checks.

The notebook generates small CSVs under `data/intermediate/original/` and
verified Parquet tables under `data/parquet/original/sample/`.
Step 4 writes full typed inputs under `data/parquet/original/raw/`, cleaned
tables under `data/parquet/original/cleaned/`, and row counts with reasons in
`reports/cleaning/original/cleaning_audit.csv`. Each cleaning rule is explained
in the notebook before its code.

For downloading instructions, read [data/README.md](data/README.md).
The original datasets are preserved. Inspection sample counts are not the
full dataset's attack distribution.

Next: join the cleaned traffic and service lookup, answer the research questions,
and compare CSV and Parquet query times.

To stop the Docker environment:

```powershell
docker compose down
```
