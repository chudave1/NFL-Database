-- public.fact_game definition

-- Drop table

-- DROP TABLE fact_game;

CREATE TABLE fact_game (
	seasonid int8 NOT NULL,
	hometeamid int8 NOT NULL,
	awayteamid int8 NOT NULL,
	gamedate date NOT NULL,
	gamenum numeric NOT NULL,
	homescore int4 NULL,
	awayscore int4 NULL,
	homewon int2 NULL,
	CONSTRAINT fact_game_pkey PRIMARY KEY (seasonid, hometeamid, awayteamid, gamedate)
);


-- public.fact_game foreign keys

ALTER TABLE public.fact_game ADD CONSTRAINT fact_game_awayteamid_fkey FOREIGN KEY (awayteamid) REFERENCES dim_team(id);
ALTER TABLE public.fact_game ADD CONSTRAINT fact_game_hometeamid_fkey FOREIGN KEY (hometeamid) REFERENCES dim_team(id);
ALTER TABLE public.fact_game ADD CONSTRAINT fact_game_seasonid_fkey FOREIGN KEY (seasonid) REFERENCES dim_season(id);