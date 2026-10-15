# How to download the project datasets

This folder holds the two source datasets for Part 1:

- **Improved CSE-CIC-IDS2018:** 10 CSV files containing network traffic.
- **IANA Service Names and Port Numbers Registry:** a CSV used to associate
  destination ports and protocols with registered services.

Use the script at [`../downloaders/download_data.py`](../downloaders/download_data.py)
to download both datasets and extract the traffic archive automatically.
It uses Python's standard library; no extra Python packages are required.
Allow at least **50 GiB of free disk space** for a fresh download and extraction.

## Option 1: from the Volume notebook

Open `notebooks/DPA_Volume_Part1.ipynb`. In the first code cell, change:

```python
DOWNLOAD_DATA = True
```

Run that cell with **Shift + Enter**. It downloads missing files into this
folder without starting Spark processing. Leave the setting at `False` to skip
downloading. This download cell does not require Docker or PySpark.

## Option 2: run the Python script directly

With Python 3.9 or later available on your computer, open PowerShell in the
**inner project folder** containing `data`, `downloaders`, and `notebooks`:

```powershell
python .\downloaders\download_data.py
```

If your terminal is in the **outer workspace folder**, use:

```powershell
python .\DPA-Volume-Part1-Project\downloaders\download_data.py
```

From a Jupyter notebook opened in the project's `notebooks` folder, you can
also run the script in a code cell:

```python
%run ../downloaders/download_data.py
```

## Option 3: use the configured Docker environment

Ensure Docker Desktop is running. From the outer workspace folder:

```powershell
docker compose up -d
docker compose exec spark python /home/jovyan/work/downloaders/download_data.py
```

## Expected files

```text
data/
  README.md
  CSECICIDS2018_improved/
    ...10 traffic CSV files...
  Service and port name/
    service-names-port-numbers.csv
  downloads/
    CSECICIDS2018_improved.zip
```

The existing filename `service-names-port-numbers (3).csv` is also accepted.
The ZIP is retained for reuse. The `parquet/` folder contains generated Spark
outputs, not downloaded source data.

The script prints download and extraction messages. It preserves existing
source CSVs and skips datasets that pass its basic checks. If interrupted,
rerun the same command: incomplete downloads restart from the beginning, while
completed CSVs are reused. Files ending in `.part` or `.extracting` are temporary
files, not completed datasets.

A successful script run ends with:

```text
SUCCESS: datasets are available. No Spark processing was performed.
```

## Official sources

- [Improved CSE-CIC-IDS2018 documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [Traffic ZIP archive directory](https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/)
- [IANA registry CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv)
