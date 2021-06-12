create schema taxi;

create table taxi.green_tripdata (
VendorID string,
lpep_pickup_datetime string,
lpep_dropoff_datetime string,
store_and_fwd_flag string,
RatecodeID string,
PULocationID string,
DOLocationID string,
passenger_count string,
trip_distance string,
fare_amount string,
extra string,
mta_tax string,
tip_amount string,
tolls_amount string,
ehail_fee string,
improvement_surcharge string,
total_amount string,
payment_type string,
trip_type string,
congestion_surcharge string )
PARTITIONED BY (trip_date string)
STORED AS INPUTFORMAT
'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';

LOAD DATA LOCAL INPATH 'https://s3.amazonaws.com/nyc-tlc/trip+data/green_tripdata_2019-01.csv' OVERWRITE INTO TABLE  taxi.green_tripdata PARTITION (trip_date='201901')
