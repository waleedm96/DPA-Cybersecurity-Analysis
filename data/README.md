# Data

Part 1 uses two datasets: the original CSE-CIC-IDS2018 traffic CSVs and the IANA service and port registry.

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
| `Dataset Network Traffic/` | Ten original traffic CSVs used in Part 1 |
| `Dataset Service and Port/` | IANA CSV |
| `Dataset Network Traffic improved/` | Optional improved release for later work |
| `downloads/` | Improved ZIP, if requested |
| `samples/` | 500 rows per traffic file for the reading test |
| `parquet/sample/` | Typed tables from the sample test |
| `parquet/raw/` | All source rows as typed Parquet |
| `parquet/cleaned/` | Cleaned traffic and IANA |
| `parquet/enriched/traffic/` | Traffic with IANA service names |

Nine original files have 80 columns; 20 February has 84. Filenames stay as provided, including `Thuesday-20-02-2018...`. Source CSVs are not changed by the notebook.

## Sources and licences

- **Original CSE-CIC-IDS2018:** [dataset description and licence](https://www.unb.ca/cic/datasets/ids-2018.html), [AWS dataset page](https://registry.opendata.aws/cse-cic-ids2018/). The provider permits redistribution and requires a dataset citation and a link to the AWS page. The downloader uses the public AWS CSV objects.
- **IANA registry:** [CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv), [licensing terms](https://www.iana.org/help/licensing-terms). The protocol registry data is covered by the CC0 1.0 dedication described there. The downloaded snapshot can change as IANA updates the registry.
- **Optional improved release:** [provider documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html). This is separate from the original data and is not part of the Part 1 analysis.
