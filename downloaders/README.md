# Download the datasets

`download_data.py` downloads the original CSE-CIC-IDS2018 CSVs, the improved
release, and the IANA registry using Python's standard library.

Run from the inner project folder:

```powershell
python .\downloaders\download_data.py
```

Files are saved under:

- `data/CSECICIDS2018_original/`
- `data/CSECICIDS2018_improved/`
- `data/Service and port name/`

Existing nonempty files are skipped. New downloads use `.part` files until
complete. After an interruption, rerun the command; the incomplete file starts
again from the beginning. Completed files are kept.

The improved release is downloaded as a ZIP under `data/downloads/` and then
extracted. Allow about 55 GB free for both releases and the retained archive.
**Part 1 uses the original CSVs and IANA.** The improved release is kept for later.

In the Volume notebook, `DOWNLOAD_DATA = True` downloads only the original
traffic CSVs and IANA. Running the script directly downloads both traffic
releases and IANA. No extra Python packages are needed.

See [data/README.md](../data/README.md) for the folder layout and source links.
