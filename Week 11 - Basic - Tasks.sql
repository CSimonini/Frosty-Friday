create database frosty_friday;
create schema challenges;

create or replace file format FF_CSV
    TYPE = 'CSV'
    SKIP_HEADER = 1;
    

create or replace stage week_11_frosty_stage
    url = 's3://frostyfridaychallenges/challenge_11/'
    file_format = (format_name = FF_CSV);
    
create or replace table frosty_friday.challenges.week11 as
select m.$1 as milking_datetime,
        m.$2 as cow_number,
        m.$3 as fat_percentage,
        m.$4 as farm_code,
        m.$5 as centrifuge_start_time,
        m.$6 as centrifuge_end_time,
        m.$7 as centrifuge_kwph,
        m.$8 as centrifuge_electricity_used,
        m.$9 as centrifuge_processing_time,
        m.$10 as task_used
from @week_11_frosty_stage (file_format => 'FF_CSV', pattern => '.*milk_data.*[.]csv') m;

select * from frosty_friday.challenges.week11;

/*
TASK 1: Remove all the centrifuge dates and centrifuge kwph and replace them with NULLs WHERE fat = 3. 
 Add note to task_used.
create or replace task whole_milk_updates
schedule = '1400 minutes'
as
<insert_sql_here>
*/

create or replace task FROSTY_FRIDAY.CHALLENGES.WHOLE_MILK_UPDATES
    warehouse = 'COMPUTE_WH'
    schedule = '1 minute'
as
    update FROSTY_FRIDAY.CHALLENGES.WEEK11
    set 
        CENTRIFUGE_START_TIME = NULL,
        CENTRIFUGE_END_TIME = NULL,
        CENTRIFUGE_KWPH = NULL,
        TASK_USED = SYSTEM$CURRENT_USER_TASK_NAME() || ' at ' || current_timestamp()
    where FAT_PERCENTAGE = 3
;   

/*
-- TASK 2: Calculate centrifuge processing time (difference between start and end time) WHERE fat != 3. 
-- Add note to task_used.
create or replace task skim_milk_updates
    after frosty_friday.challenges.whole_milk_updates
as
    <insert_sql_here>
*/

create or replace task skim_milk_updates
    warehouse = 'COMPUTE_WH'
    after FROSTY_FRIDAY.CHALLENGES.WHOLE_MILK_UPDATES
as
    update FROSTY_FRIDAY.CHALLENGES.WEEK11
    set
        CENTRIFUGE_START_TIME = CENTRIFUGE_START_TIME::timestamp_ntz,
        CENTRIFUGE_END_TIME= CENTRIFUGE_END_TIME::timestamp_ntz,
        CENTRIFUGE_PROCESSING_TIME = datediff('second', CENTRIFUGE_END_TIME::timestamp_ntz, CENTRIFUGE_START_TIME::timestamp_ntz),
        TASK_USED = SYSTEM$CURRENT_USER_TASK_NAME() || ' at ' || current_timestamp()
    where FAT_PERCENTAGE != 3
;

-- resume the tasks (!! first the second one because it's rooted)

alter task skim_milk_updates resume;
alter task whole_milk_updates resume;

-- check if the task run as it should after 1 minute
select * from table(ags_game_audience.information_schema.task_history());

-- Check that the data looks as it should
select * from week11;

-- Check that the numbers are correct
select task_used, count(*) as row_count from week11 group by task_used;

-- Suspend the tasks
alter task whole_milk_updates suspend;
alter task skim_milk_updates suspend;
