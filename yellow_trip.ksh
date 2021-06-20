create table trip.yellow_tripdata (
VendorID string,
tpep_pickup_datetime string,
tpep_dropoff_datetime string,
passenger_count int,
trip_distance double,
RatecodeID string,
store_and_fwd_flag string,
PULocationID string,
DOLocationID string,
payment_type string,
fare_amount double,
extra string,
mta_tax string,
tip_amount double,
tolls_amount double,
improvement_surcharge double,
total_amount double,
congestion_surcharge double)
PARTITIONED BY (trip_date string)
ROW FORMAT delimited fields terminated by ','
LINES TERMINATED BY '\n' STORED AS TEXTFILE;


LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_12.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201912');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_11.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201911');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_10.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201910');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_09.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201909');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_08.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201908');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_07.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201907');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_06.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201906');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_05.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201905');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_04.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201904');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_03.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201903');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_02.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201902');
LOAD DATA INPATH '/FileStore/shared_uploads//yellow_tripdata_2019_01.csv' OVERWRITE INTO TABLE  trip.yellow_tripdata PARTITION (trip_date='201901');


select VendorID,count(*) from trip.yellow_tripdata 
group by VendorID
order by VendorID desc;


select trip_date,count(tpep_pickup_datetime) as trip_count,avg(trip_distance) as avg_distance, avg(passenger_count) as avg_passenger_count
from trip.yellow_tripdata 

