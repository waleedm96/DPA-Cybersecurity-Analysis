# Download the datasets

`download_data.py` downloads the two source datasets into the project's
`data` folder and extracts the traffic ZIP. It uses Python's standard library.

In the Volume notebook, set `DOWNLOAD_DATA = True` and run the first code cell.
Keep it `False` when the files are already present.

With local Python, run from the inner project folder:

```powershell
python .\downloaders\download_data.py
```

Or use the existing Docker environment:

```powershell
docker compose exec spark python /home/jovyan/work/downloaders/download_data.py
```

Allow at least 50 GiB free for a fresh download and extraction. The script
preserves existing source CSVs. Interrupted downloads restart from the beginning
when rerun; completed files are reused. The downloaded ZIP is retained under
`data/downloads/`.

See [data/README.md](../data/README.md) for the folder layout and official links.
