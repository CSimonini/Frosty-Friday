use role sysadmin;

create or replace database frosty_friday;
use database frosty_friday;
create or replace schema w2_intermediate;

use warehouse compute_wh;

create or replace file format ff_parquet
  TYPE = parquet
;

-- MAIN URL = 'https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_2/employees.parquet'
create or replace stage w2_stage
    url = 's3://frostyfridaychallenges/challenge_2'
    file_format = ff_parquet
;

-- check the results
list @w2_stage;

-- create the row table in order to import the parquet file
create or replace table W2_Intermediate.Row_Table (
    RAW_LOG Variant
);

copy into row_table
 from @w2_stage
 FILES = ('/employees.parquet')
 file_format = (format_name = ff_parquet)
 ;

 -- Check the result
select $1 from row_table;


-- flatten for creating the regular table
create or replace table employees as (
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
from row_table f1
);

-- Check the result -> 100 rows
select * from employees;

create or replace view employees_view as (
    select 
        employee_id
        ,dept
        ,job_title 
    from employees
);

-- create the stream
create or replace stream employees_stream on view employees_view;

-- run the requested commands for the challenge
UPDATE employees SET COUNTRY = 'Japan' WHERE EMPLOYEE_ID = 8;
UPDATE employees SET LAST_NAME = 'Forester' WHERE EMPLOYEE_ID = 22;
UPDATE employees SET DEPT = 'Marketing' WHERE EMPLOYEE_ID = 25;
UPDATE employees SET TITLE = 'Ms' WHERE EMPLOYEE_ID = 32;
UPDATE employees SET JOB_TITLE = 'Senior Financial Analyst' WHERE EMPLOYEE_ID = 68;

-- Check the final result on the stream
select * from employees_stream;
