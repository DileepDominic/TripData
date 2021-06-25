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


Removing header recrods from all files
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_12.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_11.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_10.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_09.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_08.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_07.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_06.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_05.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_04.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_03.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_02.csv;
$ sed -i '1d' /FileStore/shared_uploads//green _tripdata_2019_01.csv;
										  
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
select case when v.VendorID in ('1') then 'Creative Mobile Technologies, LLC' 
	        when v.VendorID in ('2') then 'VeriFone Inc' 
			else NULL
			end as VendorName from (
select y.VendorID,count(*) as cnt from trip.green_tripdata as y
group by y.VendorID
order by cnt DESC
limit 1) as v;

Result:
VeriFone Inc


2) Find the month wise trip count, average distance and average passenger count
from the trips completed by yellow and green taxis in 2019. Summary
visualizations will be preferred for better analysis.

SQL query :
select trip_date,count(tpep_pickup_datetime) as trip_count,avg(trip_distance) as avg_distance, avg(passenger_count) as avg_passenger_count
from trip.green_tripdata 



3) Find out the five busiest routes served by the yellow and green taxis during 2019.
The name of start and drop points to be provided.

SQL Query:
select l.PULocationID , l.DOLocationID,r.Borough from
(
select l.PULocationID , l.DOLocationID, count(*) as cnt from trip.green_tripdata as g 
group by  l.PULocationID, l.DOLocationID) as t 
order by cnt desc 
limit 5 ) as l
left join trip.location_details as r
on r.LocationID = l.LocationID;

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
from trip.green_tripdata as g
) as c
group by c.start_hour,c.end_hour) as data
order by d.cnt desc



5) What is the most preferred way of payment used by the passengers? What are
the weekly trends observed for the methods of payments?

select 
case when v.payment_type in ('1') then 'Credit card'
	 when v.payment_type in ('2') then 'Cash'
	 when v.payment_type in ('3') then 'No charge'
	 when v.payment_type in ('4') then 'Dispute'
	 when v.payment_type in ('5') then 'Unknown'
	 when v.payment_type in ('6') then 'Voided trip'
end as Payment_type_name
(
select y.payment_type,count(*) as cnt from yellow_tripdata as y
group by y.payment_type
order by cnt desc
limit 1
) as v;

select 
case when v.payment_type in ('1') then 'Credit card'
	 when v.payment_type in ('2') then 'Cash'
	 when v.payment_type in ('3') then 'No charge'
	 when v.payment_type in ('4') then 'Dispute'
	 when v.payment_type in ('5') then 'Unknown'
	 when v.payment_type in ('6') then 'Voided trip'
end as Payment_type_name
(
select y.payment_type,count(*) as cnt from yellow_tripdata as y
where from_unixtime(unix_timestamp(y.tpep_pickup_datetime,'yyyyMMdd'),'u') in (1,7)
group by y.payment_type
order by cnt desc
limit 1
) as v;


