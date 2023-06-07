use database FROSTY_FRIDAY;
create schema W25_ROW;

-- MAIN URL - https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_25/ber_7d_oct_clim.json
create or replace stage FF_W25_Stage
    url = 's3://frostyfridaychallenges/challenge_25';
    
list @FF_W25_Stage;

create table FROSTY_FRIDAY.W25_ROW.W25_ROW (
RAW_LOG variant
);

create or replace file format json_ff
    type = json
    strip_outer_array = TRUE;

COPY INTO FROSTY_FRIDAY.W25_ROW.W25_ROW
from @FF_W25_Stage
files = ('/ber_7d_oct_clim.json')
file_format = (format_name = json_ff);

select * from W25_ROW;

create schema W25;

create or replace table W25_Solution as
    select 
        f2.value:"timestamp"::date as "date",
        array_agg(f2.value:"icon"::array) as Icon_array,
        AVG(f2.value:"temperature"::float) as AVG_TEMPERATURE,
        SUM(f2.value:"precipitation"::float) as Total_precipitations,
        AVG(f2.value:"wind_speed"::float) as AVG_WIND,
        AVG(f2.value:"relative_humidity"::float) as AVG_humidity
    from FROSTY_FRIDAY.W25_ROW.W25_ROW f1,
    lateral flatten (input => f1.$1:"weather", outer => TRUE, mode => 'ARRAY') f2
    group by 1
    order by 1 desc;
    
select * from W25_Solution;
