
drop table dim_season;
CREATE TABLE dim_season (
    Id BIGINT GENERATED ALWAYS AS identity primary key,
    Season INT NOT NULL,
    WeekName TEXT NOT null,
	Sunday DATE NOT null,
	FirstDate DATE not null,
	LastDate DATE not NULL
);


-- Unknown row
INSERT INTO public.dim_season (id, season, weekname, sunday, firstdate, lastdate)
OVERRIDING SYSTEM VALUE
VALUES (0, 0, 'Unknown', '2000-01-01', '2000-01-01', '2001-01-01');


INSERT INTO public.dim_season (season, weekname, sunday,  firstdate, lastdate)
SELECT DISTINCT
    season,
    week AS weekname,
    to_date(season || '/' || gamedate, 'YYYY/MM/DD'),
    ( to_date(season || '/' || gamedate, 'YYYY/MM/DD') - INTERVAL '3 days')::date,  -- Thursday
    ( to_date(season || '/' || gamedate, 'YYYY/MM/DD') + INTERVAL '1 days')::date   -- Sunday
FROM public.stage_game_results
WHERE season IS NOT null and GAMEDAY = 'SUN';
