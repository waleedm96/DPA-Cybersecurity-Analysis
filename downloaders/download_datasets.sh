#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "${SCRIPT_DIR}/.." && pwd)"
TRAFFIC_DIR="${PROJECT_ROOT}/data/Dataset Network Traffic"
IANA_DIR="${PROJECT_ROOT}/data/Dataset Service and Port"
TRAFFIC_URL="https://cse-cic-ids2018.s3.ca-central-1.amazonaws.com/Processed%20Traffic%20Data%20for%20ML%20Algorithms"
IANA_URL="https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv"

if ! command -v curl >/dev/null 2>&1; then
  echo "ERROR: curl is required." >&2
  exit 1
fi
mkdir -p "${TRAFFIC_DIR}" "${IANA_DIR}"

download() {
  local url="$1" destination="$2"
  if [[ -s "$destination" ]]; then
    echo "Already exists: $destination"
    return 0
  fi
  local partial_file="${destination}.part" attempt result
  # Keep partial downloads so retries and later runs can resume.
  for attempt in {1..5}; do
    echo "Downloading: $destination (attempt $attempt/5)"
    if curl --fail --location --connect-timeout 30 --speed-limit 1024 --speed-time 60 \
        --continue-at - --output "$partial_file" "$url"; then
      if [[ -s "$partial_file" ]] && mv -f -- "$partial_file" "$destination"; then
        return 0
      fi
    else
      result=$?
      # A server that does not support resuming needs a fresh download.
      if (( result == 33 )); then
        rm -f -- "$partial_file"
      fi
    fi
    if (( attempt < 5 )); then
      echo "Download failed. Retrying in 5 seconds..." >&2
      sleep 5
    fi
  done
  echo "ERROR: Download failed after 5 attempts: $destination. Progress is kept in .part." >&2
  return 1
}

traffic_files=(
  "Wednesday-14-02-2018_TrafficForML_CICFlowMeter.csv"
  "Thursday-15-02-2018_TrafficForML_CICFlowMeter.csv"
  "Friday-16-02-2018_TrafficForML_CICFlowMeter.csv"
  "Thuesday-20-02-2018_TrafficForML_CICFlowMeter.csv"
  "Wednesday-21-02-2018_TrafficForML_CICFlowMeter.csv"
  "Thursday-22-02-2018_TrafficForML_CICFlowMeter.csv"
  "Friday-23-02-2018_TrafficForML_CICFlowMeter.csv"
  "Wednesday-28-02-2018_TrafficForML_CICFlowMeter.csv"
  "Thursday-01-03-2018_TrafficForML_CICFlowMeter.csv"
  "Friday-02-03-2018_TrafficForML_CICFlowMeter.csv"
)
failed=0
for filename in "${traffic_files[@]}"; do
  if ! download "${TRAFFIC_URL}/${filename}" "${TRAFFIC_DIR}/${filename}"; then
    failed=1
  fi
done
if ! download "$IANA_URL" "${IANA_DIR}/service-names-port-numbers.csv"; then
  failed=1
fi
if (( failed != 0 )); then
  echo "ERROR: One or more downloads failed. Rerun to retry missing files." >&2
  exit 1
fi
echo "All ten original traffic CSVs and IANA are ready."
