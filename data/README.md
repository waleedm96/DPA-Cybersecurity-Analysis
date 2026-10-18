# Data

## Included subset

`subset/` contains ten traffic CSVs with **1,003,840 uncleaned records** in total, plus `service and port subset.csv`, an unchanged copy of the full IANA registry (**14,536 records**).

Each traffic file keeps its original columns. Rows were selected from all ten days using seed 42: 100,000 random rows per day, plus up to 100 examples per label and cleaning problem. No missing values or duplicates were invented. Extra rare and dirty records help test cleaning, but the subset proportions do not represent the full dataset.

Use `USE_SUBSET = True` in the notebook. No download is needed.

## Full data

Set `USE_SUBSET = False` and `DOWNLOAD_DATA = True` in the notebook, then restart the kernel and run all cells. Or download first from the project folder:

```powershell
python downloaders/download_data.py
```

The script downloads original traffic and IANA. Existing nonempty files are skipped. Interrupted files stay as `.part`; the script retries five times and resumes the saved download. Rerun the same command to continue after a connection problem. It uses `curl`, which is included in the project Docker image and current Windows installations. The original traffic CSVs need about 7 GB, plus space for generated tables.

Inside the running project container, use `docker compose exec jupyter python downloaders/download_data.py`. To also download and extract the optional improved release, set `DOWNLOAD_IMPROVED = True` in that file before running it.

## Folders

- `subset/`: CSVs included in Git for quick evaluation.
- `Dataset Network Traffic/`: ten original traffic files.
- `Dataset Service and Port/`: full IANA CSV.
- `samples/`: 500 rows per traffic file for the reading test.
- `parquet/`: tables created by the notebook; subset tables use `parquet/subset/`.
- `Dataset Network Traffic improved/`: optional release, unused in Part 1. The downloader only fetches it if `DOWNLOAD_IMPROVED = True`.

Nine traffic files have 80 columns; 20 February has 84. Source CSVs are never edited by the notebook.

## Sources and licences

- CSE-CIC-IDS2018: [dataset and licence](https://www.unb.ca/cic/datasets/ids-2018.html), [AWS dataset page](https://registry.opendata.aws/cse-cic-ids2018/). Cite the dataset and include the AWS link when redistributing it.
- IANA: [service and port CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv), [licensing terms](https://www.iana.org/help/licensing-terms).
- Optional improved release: [provider documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html).
