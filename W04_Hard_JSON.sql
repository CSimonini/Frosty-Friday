use database frosty_friday;
create schema W4_row;

--  MAIN URL - https://frostyfridaychallenges.s3.eu-west-1.amazonaws.com/challenge_4/Spanish_Monarchs.json
create or replace stage FF_W4_Stage
    url = 's3://frostyfridaychallenges/challenge_4';

-- Check the files in the stage
list @FF_W4_Stage;

-- Create file format
create or replace file format FF_JSON
    type = 'JSON'
    compression = 'auto'
    strip_outer_array = TRUE;

-- Create ROW Table
create or replace table FROSTY_FRIDAY.W4_ROW.Frost_Row (
    RAW_LOG Variant
);

-- Create File Format
copy into FROSTY_FRIDAY.W4_ROW.Frost_Row
 from @FF_W4_Stage
 FILES = ('/Spanish_Monarchs.json')
 file_format = (format_name = FF_JSON);
 
-- Check the result
select $1 from FROSTY_FRIDAY.W4_ROW.Frost_Row;

-- Create the right schema
create schema FROSTY_FRIDAY.W4;

create or replace table FROSTY_FRIDAY.W4.Frost as
select
    row_number()
        over(order by f3.value:Birth::varchar) as ID,
    row_number() 
        over(partition by f2.value:House::varchar 
            order by f3.value:Birth::varchar) as INTER_HOUSE_ID,
    f1.$1:Era::varchar as Era,
    f2.value:House::varchar as House,
    f3.value:Name::varchar as Name,
    f3.value:Nickname[0]::varchar as Nickname_1,
    f3.value:Nickname[1]::varchar as Nickname_2,
    f3.value:Nickname[2]::varchar as Nickname_3,
    f3.value:Birth::varchar as Birth,
    f3.value:"Place of Birth"::varchar as Place_of_Birth,
    f3.value:"Start of Reign"::varchar as "Start of Reign",
    f3.value:"Consort\/Queen Consort"[0]::varchar as "Queen or Queen Consort_1",
    f3.value:"Consort\/Queen Consort"[1]::varchar as "Queen or Queen Consort_2",
    f3.value:"Consort\/Queen Consort"[2]::varchar as "Queen or Queen Consort_3",
    f3.value:"End of Reign"::varchar as "End of Reign",
    f3.value:"Duration"::varchar as "Duration",
    f3.value:"Death"::varchar as "Death",
    f3.value:"Age at Time of Death"::varchar as "Age at Time of Death",
    f3.value:"Place of Death"::varchar as "Place of Death",
    f3.value:"Burial Place"::varchar as "Burial Place"
from FROSTY_FRIDAY.W4_ROW.Frost_Row f1,
lateral flatten(input => f1.$1:Houses) f2,
lateral flatten(input => f2.value:Monarchs) f3
order by 1,2
;

-- check the result
select * from FROSTY_FRIDAY.W4.FROST;
