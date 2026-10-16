# SENTINEL - Part 1: Volume

We are using PySpark to study network traffic with two datasets:
Improved CSE-CIC-IDS2018 and the IANA service-name and port-number registry.

## Research questions

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

## Work completed

The code is in [DPA_Volume_Part1.ipynb](notebooks/DPA_Volume_Part1.ipynb).

- Optional download: download missing datasets and extract the traffic ZIP.
- Step 1: compare headers, inspect small traffic samples and the IANA registry.
- Step 2: define explicit column types and check that the headers match.

The notebook uses only the actual dataset folders. It does not yet perform
CSV-to-Parquet ingestion, cleaning, joins, or the final research analysis.

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

## Data and outputs

- `data/CSECICIDS2018_improved/`: the 10 traffic CSV files.
- `data/Service and port name/`: the IANA CSV; the existing `(3).csv` filename is accepted.
- `reports/inspection/`: the inspection summary and header checks.

For downloading instructions, read [data/README.md](data/README.md).
The original datasets are preserved. Inspection sample counts are not the
full dataset's attack distribution.

Next is Step 3: test reading a small sample and writing typed Parquet.

To stop the Docker environment:

```powershell
docker compose down
```
