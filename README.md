# DPA - Part 1: Network Traffic Analysis

We use PySpark to analyse original CSE-CIC-IDS2018 traffic and join it with the IANA service and port registry.

## Questions

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

## Run the project

1. Install Docker Desktop and start it.
2. Open a terminal in this folder, where `docker-compose.yml` is located.
3. Start Jupyter:

   ```powershell
   docker compose up --build -d
   ```

4. Open <http://127.0.0.1:8888/lab?token=sentinel-local>.
5. Open `notebooks/DPA_Volume_Part1.ipynb` and run the cells from top to bottom.

The first code cell has two switches:

```python
USE_SUBSET = True       # Quick evaluation using the CSVs included in Git.
DOWNLOAD_DATA = False   # True downloads the full source data.
```

No data download is needed for subset mode. It uses about one million uncleaned traffic records from all ten days and a complete copy of IANA. CSVs are split by day so each file stays below GitHub's file limit.

For the final research results, set `USE_SUBSET = False`. Download the full sources first with `python downloaders/download_data.py`, or set `DOWNLOAD_DATA = True` in the notebook.

To stop Jupyter, run `docker compose down`. Data and notebook changes stay in this folder.

Without Docker, use Jupyter with Java and PySpark already installed, then install the plotting packages with `pip install -r requirements.txt`.

## Notebook steps

1. Check file headers and small samples.
2. Define the two traffic schemas and the IANA schema.
3. Test CSV reading and typed Parquet with 5,000 sample traffic rows.
4. Read all ten traffic CSVs in the selected mode, clean both datasets, and record each cleaning count.
5. Join traffic with IANA by destination port and protocol.
6. Calculate full-data summaries with Spark.
7. Plot the saved summaries.

The source traffic is about 7 GB and contains over 16 million records. Spark processes the files in parallel and saves typed Parquet without loading the full traffic table into Python memory. The source CSVs are kept unchanged.

## Files and results

- `downloaders/download_data.py`: data download script. The improved release is optional and is not used in Part 1.
- `data/README.md`: data sources, download options, licences, and folder names.
- `data/subset/`: evaluation traffic CSVs and a full IANA copy, included in Git.
- `downloaders/create_subset.py`: regenerate the evaluation CSVs from the full original files, using a fixed seed.
- `data/parquet/`: sample, raw, cleaned, and enriched tables made by full-data mode. Subset tables are in `data/parquet/subset/`.
- `reports/cleaning/original/cleaning_audit.csv`: removed and modified row counts with reasons.
- `reports/analysis/`: small result tables for all 15 source labels.
- `reports/charts/`: the four figures made in Step 7.
- `reports/subset/`: the separate cleaning log, summaries, and charts for subset mode.
- `latex_report/`: report files still to be completed by the group.

Once the result CSVs exist, the Step 7 cells can make the charts without rerunning Spark. Run the folder setup cell first.

The subset is for evaluating the pipeline quickly. It keeps the original values, including natural duplicates, missing values, infinite values, invalid measurements, and repeated headers. Extra examples retain rare labels and cleaning problems, so subset proportions and sampled record rates are not estimates of the full dataset. Full-data mode is used for the research report and the assignment's data-volume requirement.
