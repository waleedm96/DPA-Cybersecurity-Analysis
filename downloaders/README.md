# Download the data

From the project folder, run:

```powershell
python .\downloaders\download_data.py
```

The script downloads original traffic into `data/Dataset Network Traffic/`, the improved release into `data/Dataset Network Traffic improved/`, and IANA into `data/Dataset Service and Port/`. It uses Python only and skips existing nonempty files. If a download stops, run the command again. That file starts again from the beginning.

Part 1 uses the original traffic files and IANA. Its optional notebook cell downloads only these two datasets.

See [data/README.md](../data/README.md) for the folders, space needed, notebook command, and source links.
