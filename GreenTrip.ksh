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
congestion_surcharge string )
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

1) Which vendor provides the most useful data?

SQL query :
select VendorID,count(*) as cnt from trip.green_tripdata 
group by VendorID
order by cnt DESC
limit 1;

Result:
2	4699247


2) Find the month wise trip count, average distance and average passenger count
from the trips completed by yellow and green taxis in 2019. Summary
visualizations will be preferred for better analysis.

SQL query :
select trip_date,count(tpep_pickup_datetime) as trip_count,avg(trip_distance) as avg_distance, avg(passenger_count) as avg_passenger_count
from trip.green_tripdata 

Result:


3) Find out the five busiest routes served by the yellow and green taxis during 2019.
The name of start and drop points to be provided.

SQL Query:
select t.PULocationID , t.DOLocationID,t.cnt 
(
select g.PULocationID , g.DOLocationID, count(*) as cnt from trip.green_tripdata as g 
group by  PULocationID,DOLocationID) as t 
order by t.cnt desc 
limit 5;

PULocationID , DOLocationID,cnt
75	74	72191
7	7	68663
74	75	61987
41	42	56898
95	95	54085
4) What are the top 3 busiest hours of the day for the taxis?

select t.start_hour , t.end_hour,t.cnt from (
select c.start_hour , c.end_hour,count(*) as cnt from (
select from_unixtime(unix_timestamp(lpep_pickup_datetime),'HH') as start_hour, from_unixtime(unix_timestamp(lpep_dropoff_datetime),'HH') as end_hour
from green_tripdata as g
) as c
group by c.start_hour,c.end_hour) as data
order by d.cnt desc
limit 3;


5) What is the most preferred way of payment used by the passengers? What are
the weekly trends observed for the methods of payments?

select payment_type,count(*) as cnt from yellow_tripdata
group by payment_type
order by cnt desc
limit 1;

select payment_type,count(*) as cnt from yellow_tripdata
where from_unixtime(unix_timestamp(tpep_pickup_datetime,'yyyyMMdd'),'u') in (1,7)
group by payment_type
order by cnt desc
limit 1;


