use role securityadmin;

grant usage on warehouse compute_wh to role sysadmin;

use role sysadmin;

-- create or replace database FROSTY_FRIDAYS;
use database FROSTY_FRIDAYS;
create or replace schema WEEK_2;

-- Original URL https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_2/employees.parquet
create or replace stage FF_W2_STAGE
    url = 's3://frostyfridaychallenges/challenge_2'
;

-- check what's in the stage and in a file
list @FF_W2_STAGE;

-- create file format
create or replace file format FF_W2_FF_PARQUET
    type = parquet
;

-- create the table
create or replace table FF_W2_TABLE_ROW (
    RAW_LOG variant
);

COPY INTO FF_W2_TABLE_ROW
    FROM @FF_W2_STAGE
    files = ('/employees.parquet')
    file_format = (format_name = FF_W2_FF_PARQUET)
;

 -- Check the result
select $1 from FF_W2_TABLE_ROW;

-- flatten for creating the regular table
create or replace table FF_W2_TABLE as (
    select
        f1.$1:city::varchar as city
        ,f1.$1:country::varchar as country
        ,f1.$1:country_code::varchar as country_code
        ,f1.$1:dept::varchar as dept
        ,f1.$1:education::varchar as education
        ,f1.$1:email::varchar as email
        ,f1.$1:employee_id::varchar as employee_id
        ,f1.$1:first_name::varchar as first_name
        ,f1.$1:job_title::varchar as job_title
        ,f1.$1:last_name::varchar as last_name
        ,f1.$1:payroll_iban::varchar as payroll_iban
        ,f1.$1:postcode::varchar as postcode
        ,f1.$1:street_name::varchar as street_name
        ,f1.$1:time_zone::varchar as time_zone
        ,f1.$1:title::varchar as title
    from FF_W2_TABLE_ROW f1
);

-- Check the result -> 100 rows
select * from FF_W2_TABLE;

-- create the subtable
create or replace view FF_W2_VIEW as (
    select 
        employee_id
        ,dept
        ,job_title 
    from FF_W2_TABLE
);

-- create the stream
create or replace stream FF_W2_STREAM on view FF_W2_VIEW;

-- run the requested commands for the challenge
UPDATE FF_W2_TABLE SET COUNTRY = 'Japan' WHERE EMPLOYEE_ID = 8;
UPDATE FF_W2_TABLE SET LAST_NAME = 'Forester' WHERE EMPLOYEE_ID = 22;
UPDATE FF_W2_TABLE SET DEPT = 'Marketing' WHERE EMPLOYEE_ID = 25;
UPDATE FF_W2_TABLE SET TITLE = 'Ms' WHERE EMPLOYEE_ID = 32;
UPDATE FF_W2_TABLE SET JOB_TITLE = 'Senior Financial Analyst' WHERE EMPLOYEE_ID = 68;

-- Check the final result on the stream
select * from FF_W2_STREAM;
