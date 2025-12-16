SELECT rowid, season, week, gamestatus, gameday, gamedate, awayteam, awayrecord, awayscore, awaywin, hometeam, homerecord, homescore, homewin, postseason, awayseeding, homeseeding
FROM public.stage_game_results;


SELECT ds.season, ds.weekname, dth.shortname, dta.shortname, 
    case 
        when dth.teamid = 'DET' and homewon = 0 then 'We Lost!'
        when dtA.teamid = 'DET' and homewon = 1 then 'We Lost!'
        else 'We Won!'
    end as winner,
    homescore, awayscore,
    case 
        when dth.teamid <> 'DET' and dth.division = 'NFC North' then 'Divisonal Game!'
        when dta.teamid <> 'DET' and dta.division = 'NFC North' then 'Divisonal Game!'
        else ''
    end as gametype
FROM fact_game
inner join dim_season ds on ds.id = seasonid
inner join dim_team dth on dth.id = hometeamid
inner join dim_team dta on dta.id = awayteamid
where dth.teamid  = 'DET' or dta.teamid = 'DET'
order by fact_game.gamedate 
;


SELECT 
    ds.season,
    SUM(CASE WHEN dth.teamid = 'DET' THEN 1 ELSE 0 END) AS homegames,
    SUM(CASE WHEN dta.teamid = 'DET' THEN 1 ELSE 0 END) AS awaygames,
    SUM(CASE WHEN dth.teamid = 'DET' THEN homescore ELSE 0 END) AS scoredathome,
    SUM(CASE WHEN dta.teamid = 'DET' THEN awayscore ELSE 0 END) AS scoredaway,
    ROUND(AVG(CASE WHEN dth.teamid = 'DET' THEN homescore END),2) AS avgscoredathome,
    ROUND(AVG(CASE WHEN dta.teamid = 'DET' THEN awayscore END),2) AS avgscoredaway
FROM fact_game fg
INNER JOIN dim_season ds ON ds.id = fg.seasonid
INNER JOIN dim_team dth ON dth.id = fg.hometeamid
INNER JOIN dim_team dta ON dta.id = fg.awayteamid
WHERE dth.teamid = 'DET' OR dta.teamid = 'DET'
GROUP BY ds.season;



select fp.down, fp.rushdirection, ds.season, count(*) as numplays, round(avg(yardsgained), 0) as avggained
from fact_play fp
inner join dim_team dtp on dtp.id = fp.offenseteamid
inner join fact_game fg on fg.gamenum = fp.gamenum
inner join dim_season ds on ds.id = fg.seasonid
inner join dim_team dtg on (dtg.id = fg.hometeamid or dtg.id = fg.awayteamid)
where ds.season IN (2023, 2024)
  and dtg.teamid = 'DET' and dtp.teamid = 'DET'
  and fp.playtype = 'RUSH'
group by 1, 2, 3  
order by 1, 2, 3
;  

select fp.rushdirection, ds.season, count(*) as numplays, round(avg(yardsgained), 0) as avggained,
      sum(fp.istouchdown) as touchdowns, 
      sum(case when fp.offenseteamid = fp.penaltyteamid then fp.ispenalty end) as penalties
from fact_play fp
inner join dim_team dtp on dtp.id = fp.offenseteamid
inner join fact_game fg on fg.gamenum = fp.gamenum
inner join dim_season ds on ds.id = fg.seasonid
inner join dim_team dtg on (dtg.id = fg.hometeamid or dtg.id = fg.awayteamid)
where ds.season IN (2023, 2024)
  and dtg.teamid = 'DET' and dtp.teamid = 'DET'
  and fp.playtype = 'RUSH'
group by 1, 2  
order by 1, 2
;  



