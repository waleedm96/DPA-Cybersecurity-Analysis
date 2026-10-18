# Data & Licencing

## Subset 

Use `USE_SUBSET = True` in the notebook. So no need to download the data as subset is already present.

**Subset 1**

First subset contains **10 Network Traffic CSVs** with **1,003,840 uncleaned records** in total.

Each traffic file keeps their original columns. Rows were selected from all ten days using seed 42: 100,000 random rows per day, plus up to 100 examples per label and cleaning problem. No missing values or duplicates were invented. Extra rare and dirty records help test cleaning.


**Subset 2**
Subset 2 contains **service and Ports CSV**, an unchanged copy of the full IANA dataset (**14,536 records**).





## Full data

Set `USE_SUBSET = False` and `DOWNLOAD_DATA = True` in the notebook, then restart the kernel and run all cells. Or download first from the project folder:

```powershell
python downloaders/download_data.py
```

The script downloads original Network Traffic and IANA Dataset. The original traffic CSVs need about 7 GB, plus space for generated tables.

Inside the running project container, use `docker compose exec jupyter python downloaders/download_data.py`. 
To also download and extract the optional improved release, set `DOWNLOAD_IMPROVED = True` in that file before running it.



## Sources and licences

- CSE-CIC-IDS2018: [dataset and licence](https://www.unb.ca/cic/datasets/ids-2018.html), [AWS dataset page](https://registry.opendata.aws/cse-cic-ids2018/). Cite the dataset and include the AWS link when redistributing it.
- IANA: [service and port CSV](https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.csv), [licensing terms](https://www.iana.org/help/licensing-terms).
- Optional improved release: [provider documentation](https://intrusion-detection.distrinet-research.be/CNS2022/CSECICIDS2018.html).
