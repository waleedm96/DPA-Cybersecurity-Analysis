# Download the Part 1 datasets

`download_data.py` downloads both sources and extracts the traffic ZIP into
the existing project data layout. It uses Python's standard library, so there
are no packages to install. Default paths are derived from the script location,
not the terminal's current directory.

From the outer VS Code workspace folder, run in PowerShell:

```powershell
docker compose up -d
docker compose exec spark python /home/jovyan/work/downloaders/download_data.py
```

If you have working Python 3.9+ installed on Windows, you can instead run:

```powershell
python .\DPA-Volume-Part1-Project\downloaders\download_data.py
```

Windows Python is optional; the Docker command uses the verified environment.

The script creates or uses:

```text
data/
  CSECICIDS2018_improved/           # 10 extracted traffic CSVs
  Service and port name/
    service-names-port-numbers.csv # IANA registry
  downloads/
    CSECICIDS2018_improved.zip     # archive retained for reuse
```

An existing valid `service-names-port-numbers (3).csv` is also accepted and
preserved. Existing traffic CSVs are skipped after checking their required
headers and that they contain data; this does not certify every record or
perform a full checksum verification. If extraction is needed, existing files
are also checked against the ZIP's uncompressed sizes. Existing source CSVs
are never overwritten. Only the 10 known CSV filenames are extracted into the
traffic folder; ZIP CRCs are checked when their contents are read.

On a fresh download, allow at least 50 GiB free for the archive and extracted
CSV files. Downloads use Python's built-in `urlretrieve`, which streams to disk.
Messages indicate downloading and extracting; there is no percentage display.
To keep the code simple, automatic retries and download resumption were removed.
Rerun after an interruption; incomplete downloads restart from the beginning.
Completed CSVs and an already downloaded ZIP are reused.
Files still downloading end in `.part`; files still being
extracted end in `.extracting` and are not treated as completed CSVs.

Optional examples:

```powershell
# Fetch only the small IANA registry.
docker compose exec spark python /home/jovyan/work/downloaders/download_data.py --only iana

# Choose another folder inside the mounted project.
docker compose exec spark python /home/jovyan/work/downloaders/download_data.py --data-dir /home/jovyan/work/data/new_download
```

Sources:

- [Improved CSE-CIC-IDS2018 documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html)
- [Official archive directory](https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/)
- [IANA registry and CSV download](https://www.iana.org/assignments/service-names-port-numbers/)

This step only obtains source files. It does not clean, relabel, or process
the datasets with Spark.

## Verification of the earlier version on 13 October 2026

Executed successfully in the project's Docker environment:

- Default command recognized and preserved both existing datasets.
- Fresh IANA download into a temporary folder passed header validation.
- Small ZIP fixture extracted all 10 expected filenames; rerunning kept them.
- Unsafe ZIP paths were rejected and conflicting existing CSVs were preserved.
- Local HTTP Range fixture resumed a partial download and reproduced exact bytes.
- The live traffic archive's central directory was read using small HTTP Range
  requests; all 10 names and uncompressed sizes matched the existing dataset.

Temporary test data was removed. The complete 9.7 GiB traffic archive was not
downloaded again; full-size download and extraction were not executed.

The simplified version keeps the same `prepare_iana` and `prepare_traffic`
functions used by the notebook's optional download cell. The comment starting
with `cspell:ignore` tells VS Code's spelling checker to accept project-specific
words. The reported "Unknown word" messages were spelling warnings, not Python
errors.

The simplified version was checked with a fresh official IANA download, a
small ZIP extraction and rerun, preservation of the existing datasets, and
both settings of the notebook's optional download cell. All checks passed.
The full traffic archive was not downloaded or processed.
