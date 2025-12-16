SELECT * FROM public.staging_play_by_play;

select gamedate, gameid, count(*) from public.staging_play_by_play
group by gamedate, gameid
order by gamedate, gameid;

select gamedate, count(*) from public.staging_play_by_play
group by gamedate 
order by gamedate desc;

select distinct offenseteam, count(*) from public.staging_play_by_play
group by offenseteam 
order by offenseteam ;

