DROP TABLE staging_play_by_play;

CREATE TABLE staging_play_by_play (
    rowid BIGINT GENERATED ALWAYS AS identity primary key,
    GameId NUMERIC(10),
    GameDate TEXT,
    GameQuarter INT,
    GameMinute INT,
    GameSecond INT,
    OffenseTeam TEXT,
    DefenseTeam TEXT,
    Down INT,
    ToGo INT,
    YardLine INT,
    SeriesFirstDown INT,
    NextScore TEXT,
    Description TEXT,
    TeamWin TEXT,
    SeasonYear INT,
    Yards INT,
    Formation TEXT,
    PlayType TEXT,
    IsRush TEXT,
    IsPass TEXT,
    IsIncomplete TEXT,
    IsTouchdown TEXT,
    PassType TEXT,
    IsSack TEXT,
    IsChallenge TEXT,
    IsChallengeReversed TEXT,
    Challenger TEXT,
    IsMeasurement TEXT,
    IsInterception TEXT,
    IsFumble TEXT,
    IsPenalty TEXT,
    IsTwoPointConversion TEXT,
    IsTwoPointConversionSuccessful TEXT,
    RushDirection TEXT,
    YardLineFixed TEXT,
    YardLineDirection TEXT,
    IsPenaltyAccepted TEXT,
    PenaltyTeam TEXT,
    IsNoPlay TEXT,
    PenaltyType TEXT,
    PenaltyYards INT
);


DROP TABLE stage_Game_Results;
CREATE TABLE stage_Game_Results (
    rowid           BIGINT GENERATED ALWAYS AS identity primary key,
    Season          INT,
    Week            TEXT,
    GameStatus      VARCHAR(20),
    GameDay             VARCHAR(10),
    GameDate            VARCHAR(10),       -- appears MM/DD
    AwayTeam        VARCHAR(50),
    AwayRecord      VARCHAR(10),       -- contains dash, e.g. "0-1"
    AwayScore       NUMERIC(10,1),
    AwayWin         NUMERIC(10,1),
    HomeTeam        VARCHAR(50),
    HomeRecord      VARCHAR(10),
    HomeScore       NUMERIC(10,1),
    HomeWin         NUMERIC(10,1),
    PostSeason      INT
);




CREATE TABLE staging_teams (
    rowid                      BIGINT GENERATED ALWAYS AS identity primary key,
    team_name                  TEXT,
    team_name_short            TEXT,
    team_id                    TEXT,
    team_id_pfr                TEXT,
    team_conference            TEXT,
    team_division              TEXT,
    team_conference_pre2002    TEXT,
    team_division_pre2002      TEXT
);
