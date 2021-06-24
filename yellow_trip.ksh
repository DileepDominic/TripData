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
congestion_surcharge string)
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


1) Which vendor provides the most useful data?

select VendorID,count(*) as cnt from trip.yellow_tripdata 
group by VendorID
order by cnt DESC
limit 1

2	51153963


2) Find the month wise trip count, average distance and average passenger count
from the trips completed by yellow and green taxis in 2019. Summary
visualizations will be preferred for better analysis.


3) Find out the five busiest routes served by the yellow and green taxis during 2019.
The name of start and drop points to be provided.

select t.PULocationID , t.DOLocationID,t.cnt 
(
select g.PULocationID , g.DOLocationID, count(*) as cnt from trip.yellow_tripdata as g 
group by  PULocationID,DOLocationID) as t 
order by t.cnt desc 
limit 5;

264	264	565635
237	236	511084
236	237	434286
236	236	430318
237	237	414188


4) What are the top 3 busiest hours of the day for the taxis?

select t.start_hour , t.end_hour,t.cnt from (
select c.start_hour , c.end_hour,count(*) as cnt from (
selet from_unixtime(unix_timestamp(lpep_pickup_datetime),'HH') as start_hour, from_unixtime(unix_timestamp(lpep_dropoff_datetime),'HH') as end_hour
from yellow_tripdata as g
) as c
group by c.start_hour,c.end_hour) as data
order by d.cnt desc 
limit 3;

04	04	628858
05	05	743043
03	03	806634



5) What is the most preferred way of payment used by the passengers? What are
the weekly trends observed for the methods of payments?

select payment_type,count(*) from yellow_tripdata
group by payment_type
order by cnt desc
limit 1;

1	3186498

select payment_type,count(*) from yellow_tripdata
where from_unixtime(unix_timestamp(tpep_pickup_datetime,'yyyyMMdd'),'u') in (1,7)
group by payment_type
order by cnt desc
limit 1;

1 	15632404
