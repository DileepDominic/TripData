
$ sed -i '1d' /FileStore/shared_uploads//taxi+_zone_lookup.csv;

hive > LOAD DATA INPATH '/FileStore/shared_uploads//taxi+_zone_lookup.csv' OVERWRITE INTO TABLE  trip.location_details ;




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

Removing header recrods from all files
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_12.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_11.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_10.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_09.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_08.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_07.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_06.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_05.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_04.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_03.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_02.csv;
$ sed -i '1d' /FileStore/shared_uploads//yellow_tripdata_2019_01.csv;

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

201901 7667792 2.8010838491704853 1.5670782410373156
201902 7019375 2.884922669041042  1.5714201050663343
201903 7832545 2.9910582763322386 1.5751794595498654
201918 7213891 3.016725096067781  1.5388583049818283
201904 3654690 3.0012104829683186 1.5652421956445006
201911 6878111 2.928826904654259  1.541836319397068
201905 7565261 3.032936426119302  1.5694291313941449
201912 6896317 2.973420867979136  1.5508773247158378
201906 6941024 3.0785054986121843 1.5673220550742946
201907 6310419 3.1101318549524892 1.5720450699916833
201908 6073357 3.1626735872762164 1.5739075065115506
201909 6567788 3.0869740025101544 1.5494071581809936 


3) Find out the five busiest routes served by the yellow and green taxis during 2019.
The name of start and drop points to be provided.

select l.PULocationID , l.DOLocationID,r.Borough from
(
select l.PULocationID , l.DOLocationID, count(*) as cnt from trip.yellow_tripdata as g 
group by  l.PULocationID, l.DOLocationID) as t 
order by cnt desc 
limit 5 ) as l
left join trip.location_details as r
on r.LocationID = l.LocationID;

264	264	565635
237	236	511084
236	237	434286
236	236	430318
237	237	414188


4) What are the top 3 busiest hours of the day for the taxis?

select t.start_hour , t.end_hour,t.cnt from (
select c.start_hour , c.end_hour,count(*) as cnt from (
select from_unixtime(unix_timestamp(lpep_pickup_datetime),'HH') as start_hour, from_unixtime(unix_timestamp(lpep_dropoff_datetime),'HH') as end_hour
from trip.yellow_tripdata as g
) as c
group by c.start_hour,c.end_hour) as data
order by d.cnt desc


04	04	628858
05	05	743043
03	03	806634



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

Credit card

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

Credit card



hive> create table trip.location_details (
LoctionID string,
Borough string,
Zone string,
service_zone string)
ROW FORMAT delimited fields terminated by ','
LINES TERMINATED BY '\n' STORED AS TEXTFILE;





