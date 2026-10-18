# DPA - Network Traffic Analysis

We use Spark to clean network traffic data, join it with IANA service names and answer:

1. What traffic patterns distinguish normal activity from attacks?
2. Which network services and traffic characteristics are associated with different attack categories?

# Pre-Requisities
1. Git, Docker and Docker Compose should already be installed. Keep Docker running.
2. There should be at least 50 GB space present in the directory if we are downloading full data
3. We are providing the terminal commands below they work both in Windows PowerShell and Linux Terminal.


# Step by Step Process to Run Our Code

## 1. Create a folder
First we will open the Powershell or Linux terminal then we will run the below commands
```sh
#step 1 go to desired location For Example (cd 'C:\Users\Waleed\Desktop\Data Processing')
cd 'enter your desired locations'

#step 2 Create Directory
mkdir DPA-Project

#step 3 Go in the Directory
cd DPA-Project
```



## 2. We will clone the github repository using the commands mentioned below on the terminal or PowerShell
```sh
#step 1 Clone the repository
git clone https://github.com/waleedm96/DPA-Cybersecurity-Analysis.git

#step 2 move into the repository
cd DPA-Cybersecurity-Analysis
```




## 3. We will start the project by running docker command it will build our container

```sh
#Step 1: build the container as we are runing it the first time
docker compose up --build -d
```

Wait for the build to finish. Docker provides Python, Spark 4.2.0, Jupyter and the required libraries. It will take sometime to complete




## 4. Open Jupyter via two options available

**Option 1: directly run the below command to go directly to container**

Open [JupyterLab](http://127.0.0.1:8888/lab?token=sentinel-local).

**Option 2: Run the below mentioned command in browser and type the token manually**
 
 `http://127.0.0.1:8888/lab`

Enter the below token after opening the link  
```text
sentinel-local
```



## 5. Choose the dataset and parameters how you want to run the code

These settings are present in the first cell of our jupiter code

**Option1: Included subset no need to download the dataset**

```python
USE_SUBSET = True
DOWNLOAD_DATA = False
```
This uses about one million uncleaned network traffic records and full IANA Service and Port Data. Use it to evaluate the project quickly.



**Option2: Using Full datasets but need to download it before processing**

```python
USE_SUBSET = False
DOWNLOAD_DATA = True
```
This downloads all ten original traffic CSVs and IANA. The original traffic files need about 6.89 GB, plus space for Parquet and temporary files. Download time depends on the connection almost 30-40 mins. Interrupted downloads are retried and resumed when the server supports it and it using the code present in the `/downloaders` folder.

`There are separate bash and powerShell script to download the directly also they are present in /downloaders folder`



**Option3: Full datasets already downloaded:**

```python
USE_SUBSET = False
DOWNLOAD_DATA = False
```
The full dataset files must be in `data/Dataset Network Traffic/` and `data/Dataset Service and Port/`.



## 6. Runing the Code after setting the Parameters

Select **Kernel -> Restart Kernel and Run All Cells**, then wait for the results and charts. our we can run all the cell individually

we have repeat this after changing the dataset options. Use the subset to check the project and the full data for final results. The subset includes dirty records, so its percentages differ from the full dataset.




## 7. Results

1. So our Subset results are saved in `reports/subset/`. Full dataset results are saved in `reports/`.
2. Inside the selected results folder, `cleaning/original/` contains the cleaning log, `analysis/`  contains the result tables, and `charts/` contains the graphs that we make for analysis.
3. Parquet files are saved in `data/parquet/subset/` for the subset of data  and `data/parquet/` for full data.
4. Source CSVs stay unchanged. Running the same mode again replaces its generated results.



## 8. Stop Spark

Last cell contain code to stop the spark, run the command to stop it



## 9. Stop the project

Save your notebook first then run the commands mentioned below

```sh
docker compose down
```



## 10. If you want to rerun (optional)

Your files remain saved. To start again, run `docker compose up -d` and reopen Jupyter.
If port 8888 is already in use, stop the other application or container using it.
We can change Spark settings present  in `config/spark-defaults.conf` the defaults use two cores and 4 GB of driver memory.



## 11. Reading about set source and licence

Dataset sources, licence terms and download details are in [data/README.md](data/README.md).
