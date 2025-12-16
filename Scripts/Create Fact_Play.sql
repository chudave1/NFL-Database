-- public.fact_play definition

-- Drop table

-- DROP TABLE fact_play;

CREATE TABLE fact_play (
	rowid int8 NOT NULL,
	gamenum numeric NOT NULL,
	gamequarter int2 NOT NULL,
	gameminute int2 NOT NULL,
	gamesecond int2 NOT NULL,
	offenseteamid int8 NOT NULL,
	defenseteamid int8 NOT NULL,
	down int2 NULL,
	togo int2 NULL,
	formation text NULL,
	playtype text NULL,
	passtype text NULL,
	rushdirection text NULL,
	yardsgained int2 NULL,
	yardline int2 NULL,
	yardlineside text NULL,
	isrush int2 NULL,
	ispass int2 NULL,
	isincomplete int2 NULL,
	issack int2 NULL,
	istouchdown int2 NULL,
	isnoplay int2 NULL,
	isinterception int2 NULL,
	isfumble int2 NULL,
	istwopointconversion int2 NULL,
	istwopointconversiongood int2 NULL,
	ischallenge int2 NULL,
	ischallengegood int2 NULL,
	ispenalty int2 NULL,
	ispenaltyaccepted int2 NULL,
	penaltyteamid int8 NULL,
	penaltytype text NULL,
	penaltyyards int2 NULL,
	description text NULL,
	CONSTRAINT fact_play_pkey PRIMARY KEY (rowid),
	CONSTRAINT fact_play_rowid_key UNIQUE (rowid)
);


-- public.fact_play foreign keys

ALTER TABLE public.fact_play ADD CONSTRAINT fact_play_defenseteamid_fkey FOREIGN KEY (defenseteamid) REFERENCES dim_team(id);
ALTER TABLE public.fact_play ADD CONSTRAINT fact_play_offenseteamid_fkey FOREIGN KEY (offenseteamid) REFERENCES dim_team(id);