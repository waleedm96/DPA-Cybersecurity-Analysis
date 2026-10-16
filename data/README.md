# Project datasets

```text
data/
  CSECICIDS2018_original/     # Part 1: 10 original CSVs (about 6.89 GB)
  Service and port name/     # IANA registry CSV
  CSECICIDS2018_improved/     # Improved release for later work (about 36.04 GB)
  README.md
```

## Download the data

The Python script downloads the original traffic CSVs from Amazon S3,
downloads and extracts the improved-release ZIP, and downloads the IANA registry.
It uses Python's standard library and works without Docker. Allow about 55 GB
free for a fresh download of both releases, including the retained ZIP.

From the inner project folder containing `data/` and `downloaders/`, run:

```powershell
python .\downloaders\download_data.py
```

From a notebook opened in `notebooks/`, you can also run:

```python
%run ../downloaders/download_data.py
```

Or set `DOWNLOAD_DATA = True` in the Volume notebook's optional download cell.
Leave it `False` when the files are already available.

Existing nonempty CSVs are skipped, including an IANA filename ending in `(3).csv`.
A new download is saved as `.part` and renamed after it finishes. If it fails,
rerun the script: that file restarts from the beginning and completed files are
skipped. The source filename `Thuesday-20-02-2018...` is intentional.

Original CSVs go directly into `CSECICIDS2018_original/`. The improved ZIP is
saved under `downloads/` and its CSVs are extracted into `CSECICIDS2018_improved/`.
Existing extracted CSVs are kept, and interrupted extractions use `.part` files.

## Notebook status

Part 1 uses the original release and IANA. The original traffic files have
80 columns, except 20 February with 84. The notebook defines both schemas and
combines samples by column name. Extra fields are null where the source file
does not supply them; no addresses are inferred.

Generated samples are under `intermediate/original/`, Parquet tables under
`parquet/original/sample/`, and inspection reports under
`../reports/inspection/original/`. Full-data ingestion and cleaning are pending.

## Source links

- [Original traffic CSV directory](https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%20Traffic%20Data%20for%20ML%20Algorithms/)
- [Improved-release documentation and download](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [IANA registry CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv)
