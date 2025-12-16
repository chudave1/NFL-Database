-- data cleanup
UPDATE staging_play_by_play
SET offenseteam='LAR'
WHERE offenseteam='LA'
;

UPDATE staging_play_by_play
SET defenseteam ='LAR'
WHERE defenseteam='LA'
;

UPDATE staging_play_by_play
SET offenseteam='LVR'
WHERE offenseteam='LV'
;

UPDATE staging_play_by_play
SET defenseteam ='LVR'
WHERE defenseteam='LV'
;




truncate table fact_play;

INSERT INTO fact_play
(rowid, gamenum, gamequarter, gameminute, gamesecond, offenseteamid, defenseteamid, down, togo, formation, playtype, passtype, rushdirection, 
 yardsgained, yardline, yardlineside, isrush, ispass, isincomplete, issack, istouchdown, isnoplay, isinterception, isfumble, 
 istwopointconversion, istwopointconversiongood, ischallenge, ischallengegood, ispenalty, ispenaltyaccepted, penaltyteamid, 
 penaltytype, penaltyyards, description)
SELECT rowid, fg.gamenum, gamequarter, gameminute, gamesecond, ot.id, dt.id, down, togo, formation, playtype, passtype, rushdirection, 
   yards, yardlinefixed::INTEGER, yardlinedirection, isrush::INTEGER, ispass::INTEGER, isincomplete::INTEGER, issack::INTEGER, istouchdown::INTEGER, 
   isnoplay::INTEGER, isinterception::INTEGER, isfumble::INTEGER, istwopointconversion::INTEGER, istwopointconversionsuccessful::INTEGER, 
   ischallenge::INTEGER, ischallengereversed::INTEGER, ispenalty::INTEGER, ispenaltyaccepted::INTEGER, pt.id, 
   penaltytype, penaltyyards::INTEGER, description
FROM staging_play_by_play stg
    INNER join fact_game fg ON fg.gamenum = stg.gameid
    left outer join dim_team ot on ot.teamid = stg.offenseteam   -- Defaults to id 0 
    left outer join dim_team dt on dt.teamid = stg.defenseteam   -- Defaults to id 0 
    left outer join dim_team pt on pt.teamid = stg.penaltyteam 
;




-- Testing scripts

SELECT rowid, gameid, gamedate, gamequarter, gameminute, gamesecond, offenseteam, defenseteam,
ispenalty, penaltyteam, isnoplay, penaltytype, penaltyyards
FROM staging_play_by_play
where rowid = 19512;

SELECT count(*)
FROM staging_play_by_play stg
    INNER join fact_game fg ON fg.gamenum = stg.gameid
  ;

SELECT gamenum, count(*)
FROM staging_play_by_play stg
    left outer join fact_game fg ON fg.gamenum = stg.gameid
 group by 1   
  ;

SELECT rowid, count(*)
FROM staging_play_by_play stg
    left outer join fact_game fg ON fg.gamenum = stg.gameid
 where fg.gamenum is null   
 group by 1   
  ;

SELECT *
FROM staging_play_by_play stg
where stg.rowid in 
    (select rowid from staging_play_by_play spbp left outer join fact_game fg ON fg.gamenum = spbp.gameid where fg.gamenum is null)   
;

SELECT *
FROM staging_play_by_play stg
JOIN dim_season s 
    ON to_date(stg.gamedate, 'YYYY-MM-DD') BETWEEN s.firstdate AND s.lastdate
JOIN dim_team ot 
    ON stg.offenseteam = ot.teamid
--JOIN dim_team dt 
    --ON stg.defenseteam = dt.teamid
where gameid = 2023110504
;


SELECT count(*) 
FROM staging_play_by_play;

SELECT count(*) 
FROM staging_play_by_play
where length(penaltytype) > 0;

SELECT count(*) 
FROM public.fact_play;

SELECT count(*) 
FROM public.fact_play
where length(penaltytype) > 0;




