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
python .\downloaders\download_data.py
```

The script downloads both traffic releases and IANA. It needs Python only. Existing nonempty files are skipped. A failed download starts again when you rerun the script. Allow about 55 GB of free space for a fresh download, including the improved ZIP kept in `downloads/`.

From a notebook in `notebooks/`, you can also run:

```python
%run ../downloaders/download_data.py
```

The Volume notebook's `DOWNLOAD_DATA = True` downloads only original traffic and IANA. Leave it `False` if the data is already there.

Original traffic filenames stay as provided by the source, including `Thuesday-20-02-2018...`. Nine files have 80 columns and 20 February has 84. We keep the source CSVs unchanged.

Inspection reports are in `../reports/inspection/original/`. The cleaning log is `../reports/cleaning/original/cleaning_audit.csv`.

## Sources

- [Original traffic CSVs](https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%20Traffic%20Data%20for%20ML%20Algorithms/)
- [Improved dataset](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [IANA CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv)
