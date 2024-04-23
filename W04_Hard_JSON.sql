-- use role securityadmin;

-- grant usage on warehouse compute_wh to role sysadmin;

use role sysadmin;

-- create or replace database FROSTY_FRIDAYS;
use database FROSTY_FRIDAYS;
create or replace schema WEEK_4;
use schema WEEK_4;

-- Original URL https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_2/employees.parquet
create or replace stage FF_W4_STAGE
    url = 's3://frostyfridaychallenges/challenge_4'
;

-- check what's in the stage and in a file
list @FF_W4_STAGE;

-- create file format
create or replace file format FF_JSON
    type = 'JSON'
    compression = 'auto'
    strip_outer_array = TRUE -- Boolean that instructs the JSON parser to remove outer brackets (i.e. [ ])
;

-- create and populate the table
create or replace table FF_W4_TABLE_ROW (
    RAW_LOG variant
);

COPY INTO FF_W4_TABLE_ROW
    FROM @FF_W4_STAGE
    files = ('/Spanish_Monarchs.json')
    file_format = (format_name = FF_JSON)
;

-- Check the result
select $1 from FF_W4_TABLE_ROW;

create or replace table FF_W4_TABLE as
    select
         row_number()
            over(order by f3.value:Birth::varchar) as ID
        ,row_number() 
            over(partition by f2.value:House::varchar 
                order by f3.value:Birth::varchar) as INTER_HOUSE_ID
        ,f1.$1:Era::varchar as Era
        -- ,f2.value:House::varchar as House
        ,f3.value:Name::varchar as Name
        ,f3.value:Nickname[0]::varchar as Nickname_1
        ,f3.value:Nickname[1]::varchar as Nickname_2
        ,f3.value:Nickname[2]::varchar as Nickname_3
        ,f3.value:Birth::varchar as Birth
        ,f3.value:"Place of Birth"::varchar as Place_of_Birth
        ,f3.value:"Start of Reign"::varchar as "Start of Reign"
        ,f3.value:"Consort\/Queen Consort"[0]::varchar as "Queen or Queen Consort_1"
        ,f3.value:"Consort\/Queen Consort"[1]::varchar as "Queen or Queen Consort_2"
        ,f3.value:"Consort\/Queen Consort"[2]::varchar as "Queen or Queen Consort_3"
        ,f3.value:"End of Reign"::varchar as "End of Reign"
        ,f3.value:"Duration"::varchar as "Duration"
        ,f3.value:"Death"::varchar as "Death"
        ,f3.value:"Age at Time of Death"::varchar as "Age at Time of Death"
        ,f3.value:"Place of Death"::varchar as "Place of Death"
        ,f3.value:"Burial Place"::varchar as "Burial Place"
    from FF_W4_TABLE_ROW f1,
    lateral flatten(input => f1.$1:Houses) f2,
    lateral flatten(input => f2.value:Monarchs) f3
    order by 1,2
;

-- check the result
select * from FF_W4_TABLE;
