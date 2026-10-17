# Data

Part 1 uses two datasets: the original CSE-CIC-IDS2018 traffic CSVs and the IANA service and port registry.

## Included evaluation subset

`subset/` is included in Git. It contains ten `data network and traffic subset - <day>.csv` files and `service and port subset.csv`. The latter is an unchanged copy of the full IANA file. The notebook defaults to `USE_SUBSET = True`, so it can run without downloading the full sources.

The included snapshot has **1,003,840 traffic records** and **14,536 IANA records** before cleaning. Traffic files are about 30-49 MiB each. The verified subset run retains all 15 traffic labels and produces 981,351 cleaned traffic records.

Each traffic file keeps its source header and all source columns. There are 100,000 randomly selected rows per day, plus up to 100 real examples per label and per cleaning problem that were not already selected. The random seed is fixed at 42. A source row is selected once; different source rows with identical values remain natural duplicates. Missing values and invalid measurements are not invented or repaired. Each CSV stays below 90 MiB.

This is an evaluation subset with extra examples of rare labels and dirty records. Its proportions and sampled record rates do not represent the full population. Use `USE_SUBSET = False` for the full research analysis. Both modes use the same cleaning and analysis code and keep their output folders separate.

To recreate it after downloading the original files:

```powershell
python downloaders/create_subset.py
```

## Download

From the project folder:

```powershell
python downloaders/download_data.py
```

This downloads original traffic and IANA. Existing nonempty files are skipped. A failed download starts again when the script is rerun. The original traffic is about 7 GB; allow extra disk space for the generated Parquet tables and Spark temporary files.

To also download the improved release, set `DOWNLOAD_IMPROVED = True` near the top of the script. Allow about 55 GB for both releases and the improved ZIP, before Parquet and temporary files. Part 1 does not use the improved files.

## Folders

| Folder | Contents |
| --- | --- |
| `subset/` | Evaluation CSVs included in Git |
| `Dataset Network Traffic/` | Ten original traffic CSVs used in Part 1 |
| `Dataset Service and Port/` | IANA CSV |
| `Dataset Network Traffic improved/` | Optional improved release for later work |
| `downloads/` | Improved ZIP, if requested |
| `samples/full/`, `samples/subset/` | 500 rows per traffic file for the selected mode's reading test |
| `parquet/sample/` | Typed tables from the sample test |
| `parquet/raw/` | All source rows as typed Parquet |
| `parquet/cleaned/` | Cleaned traffic and IANA |
| `parquet/enriched/traffic/` | Traffic with IANA service names |
| `parquet/subset/` | Separate sample, raw, cleaned, and enriched tables for subset mode |

Nine original files have 80 columns; 20 February has 84. Filenames stay as provided, including `Thuesday-20-02-2018...`. Source CSVs are not changed by the notebook.

## Sources and licences

- **Original CSE-CIC-IDS2018:** [dataset description and licence](https://www.unb.ca/cic/datasets/ids-2018.html), [AWS dataset page](https://registry.opendata.aws/cse-cic-ids2018/). The provider permits redistribution and requires a dataset citation and a link to the AWS page. The downloader uses the public AWS CSV objects.
- **IANA registry:** [CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv), [licensing terms](https://www.iana.org/help/licensing-terms). The protocol registry data is covered by the CC0 1.0 dedication described there. The downloaded snapshot can change as IANA updates the registry.
- **Optional improved release:** [provider documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html). This is separate from the original data and is not part of the Part 1 analysis.
