
-- public.work_game1 definition

-- Drop table

-- DROP TABLE work_game1;


CREATE TABLE work_game1 (
	stage_rowid int8 NOT NULL,
	seasonid int8 NULL,
	hometeamid int8 NULL,
	awayteamid int8 NULL,
	homescore int4 NULL,
	awayscore int4 NULL,
	homewon int2 NULL,
	fullgamedate date NULL,
	CONSTRAINT work_game1_pkey PRIMARY KEY (stage_rowid)
);


-- public.work_game1 definition



truncate table work_game1;
INSERT INTO work_game1
(stage_rowid, seasonid, hometeamid, awayteamid, homescore, awayscore, homewon, fullgamedate)
SELECT distinct rowid, s.id as seasonid, ht.id as hometeamid, AT.id  as awayteamid, homescore, awayscore, homewin, 
   to_date(stg.season || '/' || gamedate, 'YYYY/MM/DD') AS fullgamedate
FROM stage_game_results stg
   INNER JOIN dim_season s ON to_date(stg.season || '/' || gamedate, 'YYYY/MM/DD') >= s.firstdate 
      AND to_date(stg.season || '/' || gamedate, 'YYYY/MM/DD') <= s.lastdate
   INNER JOIN dim_team ht ON  hometeam = ht.shortname
   INNER JOIN dim_team AT ON awayteam = AT.shortname
WHERE gamestatus = 'FINAL'
;


-- testing
select count(*) from stage_game_results sgr
WHERE gamestatus = 'FINAL' and season in (2023, 2024);

SELECT *
FROM stage_game_results stg
   INNER JOIN dim_season s ON to_date(stg.season || '/' || gamedate, 'YYYY/MM/DD') >= s.firstdate 
      AND to_date(stg.season || '/' || gamedate, 'YYYY/MM/DD') <= s.lastdate
   left JOIN dim_team ht ON  hometeam = ht.shortname
   --INNER JOIN dim_team AT ON awayteam = AT.shortname
WHERE gamestatus = 'FINAL' and STG.season in (2023, 2024) and ht.shortname is null
;

-- public.work_game2 definition

-- Drop table

-- DROP TABLE work_game2;

CREATE TABLE work_game2 (
	stageid int8 NOT NULL,
	gamenum numeric NULL,
	gamedate date NULL,
	teamid1 int8 NULL,
	teamid2 int8 NULL,
	seasonid int8 NULL,
	CONSTRAINT work_game2_pkey PRIMARY KEY (stageid)
);

ALTER TABLE work_game2 DROP CONSTRAINT work_game2_pkey;

truncate table  work_game2;

-- Insure only first play per game
INSERT INTO work_game2
(stageid, gamenum, gamedate, teamid1, teamid2, seasonid)
SELECT DISTINCT ON (stg.gameid)
    stg.rowid            AS stageid,
    stg.gameid           AS gamenum,
    to_date(stg.gamedate, 'YYYY-MM-DD') AS gamedate,
    ot.id                AS teamid1,
    dt.id                AS teamid2,
    s.id                 AS seasonid
FROM staging_play_by_play stg
JOIN dim_season s 
    ON to_date(stg.gamedate, 'YYYY-MM-DD') BETWEEN s.firstdate AND s.lastdate
JOIN dim_team ot 
    ON stg.offenseteam = ot.teamid
JOIN dim_team dt 
    ON stg.defenseteam = dt.teamid
ORDER BY 
    stg.gameid,
    stg.rowid;   -- picks first play of each game
   

-- Testing queries
select count(*)  
FROM work_game2;

SELECT gamenum, count(*)   --Should be no result
FROM work_game2
group by 1
having count(*) > 1
;

SELECT stageid, gamenum, gamedate, teamid1, teamid2, seasonid
FROM work_game2
where stageid in (41671, 41603, 215710);

SELECT rowid, gameid, gamedate, gamequarter, gameminute, gamesecond, offenseteam, defenseteam
FROM staging_play_by_play
where ROWid in (41671, 41603, 215710);






-- Now combine work tables into the fact
-- Not using a join because work_table1 and work+table2 is one top many
truncate fact_game;
INSERT INTO fact_game
(seasonid, hometeamid, awayteamid, gamedate, gamenum, homescore, awayscore, homewon)
SELECT DISTINCT
    wg1.seasonid,
    wg1.hometeamid,
    wg1.awayteamid,
    wg1.fullgamedate,
    wg2.gamenum,
    wg1.homescore,
    wg1.awayscore,
    wg1.homewon
FROM work_game1 wg1
JOIN work_game2 wg2
    ON wg1.fullgamedate = wg2.gamedate
   AND wg1.seasonid     = wg2.seasonid
   AND (
        (wg2.teamid1 = wg1.hometeamid AND wg2.teamid2 = wg1.awayteamid)
        OR
        (wg2.teamid1 = wg1.awayteamid AND wg2.teamid2 = wg1.hometeamid)
       )
;

select * from work_game2  where gamenum in (2023110504);