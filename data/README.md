# Project data

```text
data/
  Dataset Network Traffic/           # Original traffic used in Part 1
  Dataset Service and Port/          # IANA registry
  Dataset Network Traffic improved/  # Improved traffic for later work
  samples/                           # Small CSV samples
  parquet/
    sample/                          # Sample ingestion test
    raw/                             # Typed source tables
    cleaned/                         # Cleaned traffic and IANA
    enriched/traffic/                # Traffic with service names
```

## Download

From the project folder, run:

```powershell
.\downloaders\download_datasets.bat
```

On Linux or macOS, run `bash downloaders/download_datasets.sh`. These scripts download only the ten original traffic CSVs and IANA using curl. Source downloads occupy about 6.9 GB; allow additional space for Parquet outputs and Spark temporary files. Existing nonempty files are skipped, and new files replace their `.part` downloads only after successful, nonempty transfers. Failed files restart when rerun. See [downloader details](../downloaders/README.md).

From a notebook in `notebooks/`, you can also run:

```python
import runpy
downloader = runpy.run_path("../downloaders/download_data.py")
downloader["download_traffic"](data_folder)
downloader["download_iana"](data_folder)
```

Here `data_folder` is the notebook's project data path. The Volume notebook's `DOWNLOAD_DATA = True` calls these two functions automatically. Leave it `False` if the data is already there. Running the Python script directly still downloads the improved release too.

Original traffic filenames stay as provided by the source, including `Thuesday-20-02-2018...`. Nine files have 80 columns and 20 February has 84. We keep the source CSVs unchanged.

Inspection reports are in `../reports/inspection/original/`. The cleaning log is `../reports/cleaning/original/cleaning_audit.csv`.

## Sources

- [Original traffic CSVs](https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%20Traffic%20Data%20for%20ML%20Algorithms/)
- [Improved dataset](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [IANA CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv)
