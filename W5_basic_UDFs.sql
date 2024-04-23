-- use role securityadmin;

-- grant usage on warehouse compute_wh to role sysadmin;

use role sysadmin;

-- create or replace database FROSTY_FRIDAYS;
use database FROSTY_FRIDAYS;
create or replace schema WEEK_5;
use schema WEEK_5;

create or replace table FF_W5_TABLE (
    my_number int
);

insert into FF_W5_TABLE VALUES (
    25
);

CREATE OR REPLACE FUNCTION timesthree(i int)
RETURNS INT
LANGUAGE PYTHON
RUNTIME_VERSION = '3.8'
HANDLER = 'timesthree'
as
$$
def timesthree(i):
    return i*3
$$;

-- check the result
select 
     my_number
    ,timesthree(my_number) as result 
from FF_W5_TABLE
;
