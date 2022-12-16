---------- Original Data -------------

USE DATABASE FROSTY_FRIDAY;

CREATE OR REPLACE SCHEMA FROSTY_FRIDAY_W21;

create or replace table hero_powers (
hero_name VARCHAR(50),
flight VARCHAR(50),
laser_eyes VARCHAR(50),
invisibility VARCHAR(50),
invincibility VARCHAR(50),
psychic VARCHAR(50),
magic VARCHAR(50),
super_speed VARCHAR(50),
super_strength VARCHAR(50)
);
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Impossible Guard', '++', '-', '-', '-', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Clever Daggers', '-', '+', '-', '-', '-', '-', '-', '++');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Quick Jackal', '+', '-', '++', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('The Steel Spy', '-', '++', '-', '-', '+', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Agent Thundering Sage', '++', '+', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Mister Unarmed Genius', '-', '-', '-', '-', '-', '-', '-', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Doctor Galactic Spectacle', '-', '-', '-', '++', '-', '-', '-', '+');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Master Rapid Illusionist', '-', '-', '-', '-', '++', '-', '+', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Galactic Gargoyle', '+', '-', '-', '-', '-', '-', '++', '-');
insert into hero_powers (hero_name, flight, laser_eyes, invisibility, invincibility, psychic, magic, super_speed, super_strength) values ('Alley Cat', '-', '++', '-', '-', '-', '-', '-', '+');

------------------------------------------

DROP TABLE IF EXISTS hero_powers_main;

CREATE TEMP TABLE hero_powers_main AS (
    
    SELECT hero_name, UPPER(main_power) as MAIN_POWER FROM (
    
    select
        hero_name,
        'flight' as "MAIN_POWER",
        flight as VALUE
    FROM hero_powers
    WHERE flight = '++'

    UNION ALL

    select
        hero_name,
        'laser_eyes' as "MAIN_POWER",
        laser_eyes as VALUE
    FROM hero_powers
    WHERE laser_eyes = '++'

    UNION ALL

    select
        hero_name,
        'invisibility' as "MAIN_POWER",
        invisibility as VALUE
    FROM hero_powers
    WHERE invisibility = '++'

    UNION ALL

    select
        hero_name,
        'INVINCIBILITY' as "MAIN_POWER",
        INVINCIBILITY as VALUE
    FROM hero_powers
    WHERE INVINCIBILITY = '++'


    UNION ALL

    select
        hero_name,
        'psychic' as "MAIN_POWER",
        psychic as VALUE
    FROM hero_powers
    WHERE psychic = '++'

    UNION ALL

    select
        hero_name,
        'magic' as "MAIN_POWER",
        magic as VALUE
    FROM hero_powers
    WHERE magic = '++'

    UNION ALL

    select
        hero_name,
        'super_speed' as "MAIN_POWER",
        super_speed as VALUE
    FROM hero_powers
    WHERE super_speed = '++'

    UNION ALL

    select
        hero_name,
        'super_strength' as "MAIN_POWER",
        super_strength as VALUE
    FROM hero_powers
    WHERE super_strength = '++'
    )
);

-------------------------------------------------------
    
DROP TABLE IF EXISTS hero_powers_secondary;

CREATE TEMP TABLE hero_powers_secondary AS (
    
    SELECT hero_name, UPPER(secondary_power) as SECONDARY_POWER FROM (

    select
        hero_name,
        'flight' as "SECONDARY_POWER",
        flight as VALUE
    FROM hero_powers
    WHERE flight = '+'

    UNION ALL

    select
        hero_name,
        'laser_eyes' as "SECONDARY_POWER",
        laser_eyes as VALUE
    FROM hero_powers
    WHERE laser_eyes = '+'

    UNION ALL

    select
        hero_name,
        'invisibility' as "SECONDARY_POWER",
        invisibility as VALUE
    FROM hero_powers
    WHERE invisibility = '+'

    UNION ALL

        select
        hero_name,
        'invincibility' as "SECONDARY_POWER",
        invincibility as VALUE
    FROM hero_powers
    WHERE invincibility = '+'

    UNION ALL


    select
        hero_name,
        'psychic' as "SECONDARY_POWER",
        psychic as VALUE
    FROM hero_powers
    WHERE psychic = '+'


    UNION ALL

    select
        hero_name,
        'magic' as "SECONDARY_POWER",
        magic as VALUE
    FROM hero_powers
    WHERE magic = '+'

    UNION ALL

    select
        hero_name,
        'super_speed' as "SECONDARY_POWER",
        super_speed as VALUE
    FROM hero_powers
    WHERE super_speed = '+'

    UNION ALL

    select
        hero_name,
        'super_strength' as "SECONDARY_POWER",
        super_strength as VALUE
    FROM hero_powers
    WHERE super_strength = '+'
    )
);

    
----------------------------------------

DROP TABLE IF EXISTS Final_Table;
CREATE TABLE Final_Table as (
    SELECT main.hero_name, main_power, secondary_power FROM hero_powers_main main
    JOIN hero_powers_secondary sec
    ON main.hero_name = sec.hero_name
);
    
SELECT * FROM FINAL_TABLE;
