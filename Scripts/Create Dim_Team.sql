

-- Drop table
--DROP TABLE dim_team;

CREATE TABLE dim_team (
    Id BIGINT GENERATED ALWAYS AS identity primary key,
    TeamId TEXT NOT NULL,
    LongName TEXT NOT null,
    ShortName TEXT,
    Conference TEXT,
    Division TEXT,
    Pre_2002_Conference TEXT,
    Pre_2002_Division TEXT
);


-- Unknown row
INSERT INTO public.dim_team
(id, teamid, longname, shortname, conference, division, pre_2002_conference, pre_2002_division)
OVERRIDING SYSTEM VALUE
VALUES(0, 'UNK', 'Unknown Team', '', '', '', '', '');


-- Rest of rows from staging
INSERT INTO public.dim_team
(teamid, longname, shortname, conference, division, pre_2002_conference, pre_2002_division)
SELECT DISTINCT team_id, team_name, team_name_short, team_conference, team_division, team_conference_pre2002, team_division_pre2002
FROM public.staging_teams
where length(team_conference) > 0;--and length(team_division) > 0;


-- Cleanup duplicates
select * from dim_team order by id;

DELETE FROM dim_team t
WHERE id in(3, 21, 35, 29, 6, 25, 37, 5, 2);

DELETE FROM dim_team t
WHERE id in(12);

-- Add missing data
UPDATE dim_team
SET division='AFC West'
WHERE id=41
;

UPDATE dim_team
SET division='AFC West'
WHERE id=41
;

-- Got deleted somehow
INSERT INTO dim_team
(teamid, longname, shortname, conference, division, pre_2002_conference, pre_2002_division)
values('HOU', 'Houston Texans', 'Texans', 'AFC', 'AFC South', 'AFC', '');
