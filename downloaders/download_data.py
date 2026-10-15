# cspell:ignore jovyan downloaders CSECICIDS
"""Download and extract the two Part 1 datasets. No extra packages needed."""

import argparse
import csv
import sys
from pathlib import Path
from shutil import copyfileobj
from urllib.error import URLError
from urllib.request import urlretrieve
from zipfile import BadZipFile, ZipFile

# Official source links.
TRAFFIC_URL = (
    "https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/"
    "CSECICIDS2018_improved.zip"
)
IANA_URL = "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
PROJECT_DIR = Path(__file__).resolve().parents[1]

EXPECTED_FILES = (
    "Friday-02-03-2018.csv", "Friday-16-02-2018.csv", "Friday-23-02-2018.csv",
    "Thursday-01-03-2018.csv", "Thursday-15-02-2018.csv", "Thursday-22-02-2018.csv",
    "Tuesday-20-02-2018.csv", "Wednesday-14-02-2018.csv",
    "Wednesday-21-02-2018.csv", "Wednesday-28-02-2018.csv",
)
TRAFFIC_COLUMNS = {"Src IP", "Dst IP", "Dst Port", "Protocol", "Timestamp", "Label", "Attempted Category"}
IANA_COLUMNS = {"Service Name", "Port Number", "Transport Protocol"}


def valid_csv(path, required_columns):
    """Check the header and that at least some data follows it."""
    if not path.is_file():
        return False
    try:
        with path.open(encoding="utf-8-sig", newline="") as source:
            header = source.readline(65536)
            if not header.endswith("\n"):
                return False
            columns = set(next(csv.reader([header])))
            return required_columns.issubset(columns) and bool(source.read(1))
    except (OSError, UnicodeError, csv.Error, StopIteration):
        return False


def download(url, destination):
    """Save to a temporary file first, so incomplete downloads are not used."""
    destination.parent.mkdir(parents=True, exist_ok=True)
    temporary = destination.with_name(destination.name + ".part")
    print(f"Downloading {destination.name}. Please wait...", flush=True)
    urlretrieve(url, str(temporary))
    temporary.replace(destination)
    print(f"Download complete: {destination.name}")


def prepare_iana(data_dir):
    """Download the IANA CSV unless it is already available."""
    folder = data_dir / "Service and port name"
    for path in sorted(folder.glob("service-names-port-numbers*.csv")):
        if valid_csv(path, IANA_COLUMNS):
            print(f"IANA already available: {path.name}")
            return

    destination = folder / "service-names-port-numbers.csv"
    if destination.exists():
        raise ValueError(f"Please review this existing file; it was preserved: {destination}")
    temporary = folder / "service-names-port-numbers.download"
    download(IANA_URL, temporary)
    if not valid_csv(temporary, IANA_COLUMNS):
        raise ValueError("The downloaded IANA file is not a valid registry CSV.")
    temporary.replace(destination)
    print("IANA dataset ready.")


def extract_traffic(archive_path, folder):
    """Extract only the 10 known CSV names into the traffic folder."""
    folder.mkdir(parents=True, exist_ok=True)
    with ZipFile(archive_path) as archive:
        if not set(EXPECTED_FILES).issubset(archive.namelist()):
            raise ValueError("The ZIP does not contain all 10 expected traffic CSVs.")
        for name in EXPECTED_FILES:
            destination = folder / name
            if destination.exists():
                if not valid_csv(destination, TRAFFIC_COLUMNS) or destination.stat().st_size != archive.getinfo(name).file_size:
                    raise ValueError(f"Please review this existing file; it was preserved: {destination}")
                print(f"Keeping {name}")
                continue

            print(f"Extracting {name}...", flush=True)
            temporary = destination.with_name(name + ".extracting")
            with archive.open(name) as source, temporary.open("wb") as output:
                copyfileobj(source, output, length=1024 * 1024)
            if not valid_csv(temporary, TRAFFIC_COLUMNS):
                raise ValueError(f"The extracted file is not a valid traffic CSV: {name}")
            temporary.replace(destination)


def prepare_traffic(data_dir):
    """Download and extract the traffic dataset unless all CSVs exist."""
    folder = data_dir / "CSECICIDS2018_improved"
    if all(valid_csv(folder / name, TRAFFIC_COLUMNS) for name in EXPECTED_FILES):
        print("All 10 traffic CSVs are already available.")
        return

    archive = data_dir / "downloads" / "CSECICIDS2018_improved.zip"
    if not archive.exists():
        print("Allow at least 50 GiB free for the ZIP and extracted data.")
        download(TRAFFIC_URL, archive)
    extract_traffic(archive, folder)
    print("Traffic dataset ready.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--data-dir", type=Path, default=PROJECT_DIR / "data")
    parser.add_argument("--only", choices=("both", "iana", "traffic"), default="both")
    args = parser.parse_args()
    print(f"Data folder: {args.data_dir.resolve()}")
    try:
        if args.only in ("both", "iana"):
            prepare_iana(args.data_dir)
        if args.only in ("both", "traffic"):
            prepare_traffic(args.data_dir)
    except KeyboardInterrupt:
        print("\nStopped. Rerun to try again; incomplete downloads restart from the beginning.")
        return 130
    except (OSError, ValueError, BadZipFile, URLError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1
    print("SUCCESS: datasets are available. No Spark processing was performed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
