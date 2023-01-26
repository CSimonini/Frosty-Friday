use database frosty_friday;
create schema frosty_friday.w16_row;

create or replace file format json_ff
    type = json
    strip_outer_array = TRUE;
    
create or replace stage week_16_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_16/'
    file_format = json_ff;
    
list @week_16_frosty_stage;

create or replace table w16_variant (
    ROW_LOG Variant);
    
copy into FROSTY_FRIDAY.W16_ROW.W16_VARIANT
from @week_16_frosty_stage
files = ('week16.json')
file_format = (format_name = json_ff);

select $1 from @week_16_frosty_stage;

create schema w16;

create or replace table FROSTY_FRIDAY.W16.W16_Solution_Table as
    select 
        f1.$1:word::varchar as word,
        f1.$1:url::varchar as url,
        f3.value:"partOfSpeech"::varchar as part_of_speech,
        f4.value:"synonyms"::varchar as "general_synonyms",
        f4.value:"antonyms"::varchar as "general_antonyms",
        f4.value:"definition"::varchar as definition,
        f4.value:"example"::varchar as "example_if_applicable",
        f4.value:"synonyms"::varchar as "definitional_synonyms",
        f4.value:"antonyms"::varchar as "definitional_antonyms"
    from FROSTY_FRIDAY.W16_ROW.W16_VARIANT f1,
    lateral flatten(input => f1.$1:"definition", outer => TRUE, mode => 'ARRAY') f2, --> Column Configuration for a regular count(*) later
    lateral flatten(input => f2.value:"meanings", outer => TRUE, mode => 'ARRAY') f3,
    lateral flatten(input => f3.value:"definitions", outer => TRUE, mode => 'ARRAY') f4
;

GRANT ADD SEARCH OPTIMIZATION ON SCHEMA FROSTY_FRIDAY.W16 TO ROLE SYSADMIN; --Search Optimization Service
select count(*) from FROSTY_FRIDAY.W16.W16_SOLUTION_TABLE;
select count(distinct word) from FROSTY_FRIDAY.W16.W16_SOLUTION_TABLE;
