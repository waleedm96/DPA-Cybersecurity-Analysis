# cspell:ignore CSECICIDS Thuesday
"""Download original and improved traffic CSVs and the IANA registry."""

from pathlib import Path
from shutil import copyfileobj
from urllib.request import urlretrieve
from zipfile import BadZipFile, ZipFile

# Save downloads inside the project data folder.
data_folder = Path(__file__).resolve().parents[1] / "data"
DOWNLOAD_IMPROVED = False  # Part 1 only needs the original traffic and IANA.
TRAFFIC_BASE_URL = (
    "https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/"
    "Processed%20Traffic%20Data%20for%20ML%20Algorithms/"
)
IANA_URL = "https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
IMPROVED_URL = (
    "https://intrusion-detection.distrinet-research.be/CNS2022/Datasets/"
    "CSECICIDS2018_improved.zip"
)

TRAFFIC_FILES = [
    "Wednesday-14-02-2018_TrafficForML_CICFlowMeter.csv",
    "Thursday-15-02-2018_TrafficForML_CICFlowMeter.csv",
    "Friday-16-02-2018_TrafficForML_CICFlowMeter.csv",
    "Thuesday-20-02-2018_TrafficForML_CICFlowMeter.csv",
    "Wednesday-21-02-2018_TrafficForML_CICFlowMeter.csv",
    "Thursday-22-02-2018_TrafficForML_CICFlowMeter.csv",
    "Friday-23-02-2018_TrafficForML_CICFlowMeter.csv",
    "Wednesday-28-02-2018_TrafficForML_CICFlowMeter.csv",
    "Thursday-01-03-2018_TrafficForML_CICFlowMeter.csv",
    "Friday-02-03-2018_TrafficForML_CICFlowMeter.csv",
]


def download(url, destination):
    """Skip existing files; use .part until a new download finishes."""
    if destination.is_file() and destination.stat().st_size > 0:
        print(f"Already exists: {destination.name}", flush=True)
        return
    destination.parent.mkdir(parents=True, exist_ok=True)
    partial_file = destination.with_name(destination.name + ".part")
    print(f"Downloading: {destination.name}", flush=True)
    # Use the final filename only after the download finishes.
    urlretrieve(url, str(partial_file))
    partial_file.replace(destination)


def download_traffic(data_folder):
    folder = data_folder / "Dataset Network Traffic"
    # Download the ten original traffic files one at a time.
    for filename in TRAFFIC_FILES:
        download(TRAFFIC_BASE_URL + filename, folder / filename)


def download_improved(data_folder):
    folder = data_folder / "Dataset Network Traffic improved"
    # This release uses shorter filenames and the spelling "Tuesday".
    filenames = [name.replace("_TrafficForML_CICFlowMeter", "").replace("Thuesday", "Tuesday")
                 for name in TRAFFIC_FILES]
    if all((folder / name).is_file() and (folder / name).stat().st_size > 0
           for name in filenames):
        print("Improved dataset already exists.", flush=True)
        return
    archive = data_folder / "downloads" / "CSECICIDS2018_improved.zip"
    download(IMPROVED_URL, archive)
    folder.mkdir(parents=True, exist_ok=True)
    with ZipFile(archive) as source:
        for name in filenames:
            destination = folder / name
            if destination.is_file() and destination.stat().st_size > 0:
                continue
            print(f"Extracting: {name}", flush=True)
            partial_file = destination.with_name(name + ".part")
            # Copy small chunks so the whole CSV is not kept in memory.
            with source.open(name) as csv_file, partial_file.open("wb") as output:
                copyfileobj(csv_file, output, length=1024 * 1024)
            partial_file.replace(destination)


def download_iana(data_folder):
    file_path = data_folder / "Dataset Service and Port" / "service-names-port-numbers.csv"
    download(IANA_URL, file_path)


def main():
    download_traffic(data_folder)
    download_iana(data_folder)
    if DOWNLOAD_IMPROVED:
        download_improved(data_folder)
    print("Download process finished.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, BadZipFile, KeyError) as error:
        raise SystemExit(f"Download failed: {error}. Rerun to try again.") from None
