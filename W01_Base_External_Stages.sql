-- grant warehouse usage to sysadmin
use role securityadmin;

grant usage on warehouse compute_wh to role sysadmin;

-- create DB, Schema, Stage 
use role sysadmin;

create or replace database FROSTY_FRIDAYS;
use database FROSTY_FRIDAYS;
create or replace schema WEEK_1;

create or replace stage FF_W1_STAGE
    url = 's3://frostyfridaychallenges/challenge_1/'
;

-- check what's in the stage and in a file
list @FF_W1_STAGE;  --> three CSV files

select $1 from @FROSTY_FRIDAYS.PUBLIC.FF_W1_STAGE;

-- create file format
CREATE OR REPLACE FILE FORMAT FF_W1_FF
    SKIP_HEADER = 1
    TYPE = 'CSV'
    FIELD_DELIMITER = ',';

-- create table
create or replace table FF_W1_TABLE (
    COLUMN_1 VARCHAR
);

-- copy into table
COPY INTO FF_W1_TABLE
    FROM @FF_W1_STAGE
    PATTERN = '.*[1-3].csv'
    FILE_FORMAT = (format_name = 'FF_W1_FF')
;

-- check the output
select
    *
from FF_W1_TABLE
;
