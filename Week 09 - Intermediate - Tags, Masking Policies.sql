-- use role securityadmin;

-- grant usage on warehouse compute_wh to role sysadmin;

use role sysadmin;

-- create or replace database FROSTY_FRIDAYS;
use database FROSTY_FRIDAYS;
create or replace schema WEEK_9;
use schema WEEK_9;

--CREATE DATA
CREATE OR REPLACE TABLE data_to_be_masked(first_name varchar, last_name varchar,hero_name varchar);
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Eveleen', 'Danzelman','The Quiet Antman');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Harlie', 'Filipowicz','The Yellow Vulture');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Mozes', 'McWhin','The Broken Shaman');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Horatio', 'Hamshere','The Quiet Charmer');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Julianna', 'Pellington','Professor Ancient Spectacle');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Grenville', 'Southouse','Fire Wonder');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Analise', 'Beards','Purple Fighter');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Darnell', 'Bims','Mister Majestic Mothman');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Micky', 'Shillan','Switcher');
INSERT INTO data_to_be_masked (first_name, last_name, hero_name) VALUES ('Ware', 'Ledstone','Optimo');

-------------------------------
-- Grant permissions for the created roles

USE ROLE useradmin;
CREATE OR REPLACE ROLE FOO1;
CREATE OR REPLACE ROLE FOO2;

GRANT ROLE FOO1 TO ROLE USERADMIN;
GRANT ROLE FOO2 TO ROLE USERADMIN;

USE ROLE ACCOUNTADMIN;
GRANT ALL ON DATABASE FROSTY_FRIDAYS TO ROLE FOO1;
GRANT ALL ON DATABASE FROSTY_FRIDAYS TO ROLE FOO2;

GRANT ALL ON SCHEMA WEEK_9 TO ROLE FOO1;
GRANT ALL ON SCHEMA WEEK_9 TO ROLE FOO2;


GRANT ALL ON TABLE data_to_be_masked TO ROLE FOO1;
GRANT ALL ON TABLE data_to_be_masked TO ROLE FOO2;

GRANT USAGE ON WAREHOUSE compute_wh TO ROLE FOO1;
GRANT USAGE ON WAREHOUSE compute_wh TO ROLE FOO2;

-------------------------------
-- Tags to columns

CREATE OR REPLACE TAG masked_col ALLOWED_VALUES 'first', 'last';

-- Associate the tags to the columns
ALTER TABLE data_to_be_masked ALTER COLUMN first_name SET TAG masked_col = 'first';
ALTER TABLE data_to_be_masked ALTER COLUMN last_name SET TAG masked_col = 'last';

-- Check the results
select SYSTEM$GET_TAG('masked_col', 'data_to_be_masked.first_name', 'COLUMN');
select SYSTEM$GET_TAG('masked_col', 'data_to_be_masked.last_name', 'COLUMN');

-------------------------------
-- Masking policies

-- Create masking policy
CREATE OR REPLACE MASKING POLICY mask_admin AS (val STRING) RETURNS STRING ->
  CASE
    WHEN ((SYSTEM$GET_TAG_ON_CURRENT_COLUMN('masked_col') = 'first'
        OR SYSTEM$GET_TAG_ON_CURRENT_COLUMN('masked_col') = 'last'))
        AND is_role_in_session('accountadmin')
        THEN '****'
    WHEN SYSTEM$GET_TAG_ON_CURRENT_COLUMN('masked_col') = 'last'
        AND is_role_in_session('foo1')
        THEN '****'
    ELSE val
  END;


-- Apply masking policy to last_name column
ALTER TABLE data_to_be_masked MODIFY 
    COLUMN first_name SET MASKING POLICY mask_admin
    ,COLUMN last_name SET MASKING POLICY mask_admin
;

-- Check the results
use role accountadmin;
select * from data_to_be_masked;

use role foo1;
select * from data_to_be_masked;

use role foo2;
select * from data_to_be_masked;
