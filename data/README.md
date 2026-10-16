# Project data

Part 1 uses the original traffic files and IANA. We keep the improved release for later work.

```text
data/
  CSECICIDS2018_original/    # 10 original traffic CSVs, about 6.89 GB
  Service and port name/    # IANA CSV
  CSECICIDS2018_improved/    # Improved traffic CSVs, about 36.04 GB
```

## Download

From the project folder containing `data/` and `downloaders/`, run:

```powershell
python .\downloaders\download_data.py
```

This downloads both traffic releases and IANA. It needs Python only. Allow about 55 GB of free space, including the improved dataset ZIP saved in `data/downloads/`.

From a notebook opened in `notebooks/`, you can also run:

```python
%run ../downloaders/download_data.py
```

To download only the original traffic files and IANA, set `DOWNLOAD_DATA = True` in the Volume notebook. Leave it `False` if the data is already there.

Existing nonempty CSVs are skipped. New files use `.part` until they finish downloading or extracting. If a download stops, run it again: the incomplete file starts again, and completed files are kept. The script also accepts the existing IANA filename ending in `(3).csv`.

The source spelling `Thuesday-20-02-2018...` is correct for the original download URL. Nine original files have 80 columns; this file has 84. The notebook handles both layouts.

## Generated files

The notebook saves samples in `intermediate/original/` and Parquet in `parquet/original/`:

- `sample/`: the small ingestion test.
- `raw/`: all source rows before cleaning.
- `cleaned/`: the cleaned tables.

Inspection reports are in `../reports/inspection/original/`. Cleaning counts and reasons are in `../reports/cleaning/original/cleaning_audit.csv`. Some IANA rows are excluded because our lookup uses individual TCP/UDP ports; this does not make those registry entries errors.

## Sources

- [Original traffic CSVs](https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%20Traffic%20Data%20for%20ML%20Algorithms/)
- [Improved dataset](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [IANA CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv)
