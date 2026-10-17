#!/usr/bin/env bash
set -Eeuo pipefail


SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
DATA_DIR="${PROJECT_ROOT}/data"
DATASET1_DEST="${DATA_DIR}/raw/dataset_1"
DATASET2_DEST="${DATA_DIR}/raw/dataset_2"

S3_BUCKET="s3://cse-cic-ids2018/Processed Traffic Data for ML Algorithms/"
AWS_REGION="ca-central-1"
IANA_URL="https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"
IANA_FILE="${DATASET2_DEST}/service-names-port-numbers.csv"

echo "============================================"
echo "   CIC-IDS2018 + IANA Dataset Downloader"
echo "============================================"
echo
echo "Project root: ${PROJECT_ROOT}"
echo

# Ensure the existing project data directory is present.
if [[ ! -d "${DATA_DIR}" ]]; then
  echo "ERROR: Existing project data directory not found:" >&2
  echo "  ${DATA_DIR}" >&2
  echo "Keep this script inside the project's downloaders/ directory." >&2
  exit 1
fi

# Check required tools.
if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI was not found." >&2
  echo "Install AWS CLI v2: https://aws.amazon.com/cli/" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl was not found. Install curl and try again." >&2
  exit 1
fi

mkdir -p "${DATASET1_DEST}" "${DATASET2_DEST}"

echo "AWS CLI version:"
aws --version
echo

dataset1_failed=0
dataset2_failed=0

echo "============================================"
echo "Downloading Dataset 1: CIC-IDS2018 processed CSVs"
echo "============================================"
echo "Destination: ${DATASET1_DEST}"
echo

if aws s3 sync \
  --no-sign-request \
  --region "${AWS_REGION}" \
  "${S3_BUCKET}" \
  "${DATASET1_DEST}/"; then
  echo "Dataset 1 sync completed."
else
  echo "ERROR: Dataset 1 download failed." >&2
  echo "Check internet access, disk space, and AWS CLI, then rerun this script." >&2
  dataset1_failed=1
fi

echo
echo "============================================"
echo "Downloading Dataset 2: IANA service/port CSV"
echo "============================================"
echo "Source: ${IANA_URL}"
echo "Destination: ${IANA_FILE}"
echo

# Download to a temporary file first so a failed request won't replace a
# previously downloaded good copy with an incomplete file.
tmp_file="$(mktemp "${DATASET2_DEST}/.iana-download.XXXXXX")"
if curl --fail --location --silent --show-error \
  --output "${tmp_file}" "${IANA_URL}"; then
  if [[ -s "${tmp_file}" ]]; then
    mv -f -- "${tmp_file}" "${IANA_FILE}"
    echo "Dataset 2 download completed."
  else
    echo "ERROR: IANA download returned an empty file." >&2
    rm -f -- "${tmp_file}"
    dataset2_failed=1
  fi
else
  echo "ERROR: Dataset 2 download failed. Check your internet connection and retry." >&2
  rm -f -- "${tmp_file}"
  dataset2_failed=1
fi

echo
echo "============================================"
echo "Download Summary"
echo "============================================"
echo "Dataset 1 folder: ${DATASET1_DEST}"
echo "Dataset 2 folder: ${DATASET2_DEST}"
echo

csv_count="$(find "${DATASET1_DEST}" -type f -iname '*.csv' -print 2>/dev/null | wc -l | tr -d ' ')"
echo "Dataset 1 CSV files found: ${csv_count}"

if [[ -f "${IANA_FILE}" ]]; then
  echo "Dataset 2 file: ${IANA_FILE}"
  echo "Dataset 2 size: $(du -h "${IANA_FILE}" | awk '{print $1}')"
fi

if (( dataset1_failed != 0 || dataset2_failed != 0 )); then
  echo
  echo "WARNING: One or more downloads failed. Fix the reported issue and rerun this script."
  exit 1
fi

echo
echo "All downloads completed successfully."
