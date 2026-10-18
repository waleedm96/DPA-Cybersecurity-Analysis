"""Smoke test: verify Spark, Spark SQL and Parquet in our Docker container."""
from pathlib import Path

from pyspark.sql import SparkSession
from pyspark.sql.types import IntegerType, StringType, StructField, StructType

spark = (
    SparkSession.builder
    .appName("DPA-Volume-Installation-Test")
    .getOrCreate()
)
spark.sparkContext.setLogLevel("ERROR")
assert spark.version == "4.2.0", f"Expected Spark 4.2.0, found {spark.version}"
conf = spark.sparkContext.getConf()
assert conf.get("spark.serializer") == "org.apache.spark.serializer.KryoSerializer", (
    "Project spark-defaults.conf was not loaded"
)
assert spark.conf.get("spark.sql.shuffle.partitions") == "48"
assert conf.get("spark.driver.memory") == "4g"
assert spark.sparkContext.master == "local[2]"
print("Project Spark defaults loaded; master:", spark.sparkContext.master)
print("Actual JVM maximum heap (GiB):",
      spark.sparkContext._jvm.java.lang.Runtime.getRuntime().maxMemory() / 1024**3)

schema = StructType([
    StructField("src_ip", StringType(), False),
    StructField("dst_port", IntegerType(), False),
    StructField("label", StringType(), False),
])

rows = [
    ("192.168.1.10", 80, "Benign"),
    ("192.168.1.11", 443, "Benign"),
    ("192.168.1.12", 22, "Attack"),
    ("192.168.1.13", 22, "Attack"),
]

df = spark.createDataFrame(rows, schema)
print("\n=== SPARK VERSION ===")
print(spark.version)
print("\n=== EXPLICIT SCHEMA ===")
df.printSchema()
print("\n=== SAMPLE DATA ===")
df.show()

df.createOrReplaceTempView("network_flows")
print("\n=== SPARK SQL RESULTS ===")
label_counts = spark.sql(
    "SELECT label, COUNT(*) AS flows FROM network_flows GROUP BY label ORDER BY label"
)
label_counts.show()
assert {row.label: row.flows for row in label_counts.collect()} == {
    "Attack": 2,
    "Benign": 2,
}, "Spark SQL label counts were incorrect"

output = Path(__file__).resolve().parents[1] / "data" / "parquet" / "installation_test"
output.parent.mkdir(parents=True, exist_ok=True)
df.write.mode("overwrite").parquet(str(output))
read_back = spark.read.parquet(str(output))
assert read_back.count() == 4, "Parquet read-back count was incorrect"
assert [(field.name, field.dataType) for field in read_back.schema] == [
    (field.name, field.dataType) for field in schema
], "Parquet column names or types changed"
assert sorted(tuple(row) for row in read_back.collect()) == sorted(rows), (
    "Parquet read-back contents were incorrect"
)

print("\nSUCCESS: Spark, SQL, schema, Parquet write, and Parquet read are working!")
print(f"Parquet saved at {output}")
spark.stop()
