# Download the data

For the two datasets used by the notebook, run one of these from the project folder.

Windows:

```powershell
.\downloaders\download_datasets.bat
```

Linux or macOS:

```bash
bash downloaders/download_datasets.sh
```

Both scripts require curl (Windows uses `curl.exe`); AWS CLI is not required. They download exactly ten original traffic CSVs into `data/Dataset Network Traffic/` and IANA into `data/Dataset Service and Port/`. They skip existing nonempty final files, write new downloads to `.part`, reject empty downloads, and return exit code 1 if any transfer fails. Rerun to retry missing files; interrupted files restart rather than resume. Existing nonempty files are assumed complete, without checksum validation. Run only one downloader at a time.

The Python script's command-line entry point still downloads the improved release as well. For the chosen two-dataset workflow, use the native scripts above or the notebook's optional download cell.

Part 1 uses the original traffic files and IANA. Its optional notebook cell downloads only these two datasets.

See [data/README.md](../data/README.md) for the folders, space needed, notebook command, and source links.
