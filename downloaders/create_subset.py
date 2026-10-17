"""Select evaluation records from the original CSVs without cleaning them."""

import csv
import math
import random
from collections import defaultdict
from pathlib import Path
from shutil import copyfile

data_folder = Path(__file__).resolve().parents[1] / "data"
ROWS_PER_DAY = 100_000
EXAMPLES_PER_GROUP = 100


def find_problem(row, columns):
    if len(row) != len(columns):
        return "malformed"
    required = ["Dst Port", "Protocol", "Timestamp", "Flow Duration", "Tot Fwd Pkts",
                "Tot Bwd Pkts", "TotLen Fwd Pkts", "TotLen Bwd Pkts",
                "Flow Byts/s", "Flow Pkts/s", "Label"]
    if any(row[columns[name]].strip().lower() in ("", "nan") for name in required):
        return "missing"
    try:
        port, protocol, duration, sent, received, sent_bytes, received_bytes, byte_rate, packet_rate = [
            float(row[columns[name]]) for name in required if name not in ("Timestamp", "Label")]
    except ValueError:
        return "malformed"
    numbers = [port, protocol, duration, sent, received, sent_bytes, received_bytes, byte_rate, packet_rate]
    if not all(math.isfinite(value) for value in numbers):
        return "infinite"
    if (not 0 <= port <= 65535 or not 0 <= protocol <= 255 or min(numbers) < 0
            or (sent == 0 and sent_bytes > 0) or (received == 0 and received_bytes > 0)):
        return "impossible"
    return None


def main():
    source_folder = data_folder / "Dataset Network Traffic"
    subset_folder = data_folder / "subset"
    files = sorted(source_folder.glob("*.csv"))
    assert len(files) == 10, "Download all ten original traffic files first."
    iana_file = data_folder / "Dataset Service and Port" / "service-names-port-numbers.csv"
    assert iana_file.is_file(), "Download the IANA CSV first."
    subset_folder.mkdir(parents=True, exist_ok=True)
    total = 0

    for path in files:
        rng = random.Random(42)
        sample = []
        examples = defaultdict(list)
        with path.open(encoding="utf-8-sig", newline="") as source:
            reader = csv.reader(source)
            header = next(reader)
            columns = {name: index for index, name in enumerate(header)}
            for number, row in enumerate(reader, start=1):
                record = (number, row)
                # Reservoir sampling gives each source row the same chance.
                if number <= ROWS_PER_DAY:
                    sample.append(record)
                else:
                    position = rng.randrange(number)
                    if position < ROWS_PER_DAY:
                        sample[position] = record

                label = row[columns["Label"]] if len(row) == len(header) else "malformed"
                problem = find_problem(row, columns)
                for group in [("label", label), ("problem", problem)]:
                    if group[1] is not None and len(examples[group]) < EXAMPLES_PER_GROUP:
                        examples[group].append(record)

        # Select a source position once, even if it meets several conditions.
        # Different original rows with identical values remain duplicates.
        selected = dict(sample)
        for records in examples.values():
            selected.update(records)
        day = path.name.replace("_TrafficForML_CICFlowMeter.csv", "")
        destination = subset_folder / f"data network and traffic subset - {day}.csv"
        partial = destination.with_suffix(".csv.part")
        with partial.open("w", encoding="utf-8", newline="") as output:
            writer = csv.writer(output, lineterminator="\n")
            writer.writerow(header)
            writer.writerows(selected[number] for number in sorted(selected))
        assert partial.stat().st_size < 90 * 1024**2, "A subset file exceeds the 90 MiB target."
        partial.replace(destination)
        total += len(selected)
        print(f"{destination.name}: {len(selected):,} of {number:,} rows", flush=True)

    copyfile(iana_file, subset_folder / "service and port subset.csv")
    print(f"Total traffic records: {total:,}. Original CSV values were not changed.")


if __name__ == "__main__":
    main()
