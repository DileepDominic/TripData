create schema trip;
create table trip.green_tripdata (
VendorID string,
lpep_pickup_datetime string,
lpep_dropoff_datetime string,
store_and_fwd_flag string,
RatecodeID string,
PULocationID string,
DOLocationID string,
passenger_count int,
trip_distance double,
fare_amount double,
extra double,
mta_tax string,
tip_amount double,
tolls_amount double,
ehail_fee string,
improvement_surcharge double,
total_amount double,
payment_type string,
trip_type string,
congestion_surcharge double )
PARTITIONED BY (trip_date string)
ROW FORMAT delimited fields terminated by ','
LINES TERMINATED BY '\n' STORED AS TEXTFILE;


LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_12.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201912');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_11.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201911');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_10.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201910');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_09.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201909');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_08.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201908');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_07.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201907');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_06.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201906');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_05.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201905');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_04.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201904');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_03.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201903');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_02.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201902');
LOAD DATA INPATH '/FileStore/shared_uploads//green_tripdata_2019_01.csv' OVERWRITE INTO TABLE  trip.green_tripdata PARTITION (trip_date='201901');

