
drop index index_gd_match_id;
drop index index_gd_playerId;

CREATE INDEX index_gd_match_id ON gameDetail (match_id);
CREATE INDEX index_gd_playerId ON gameDetail (playerId);

drop index index_pl_playerId;
drop index index_pl_playerName;
drop index index_pl_SEASON;
drop index index_pl_team;
CREATE INDEX index_pl_playerId ON players (playerId);
CREATE INDEX index_pl_playerName ON players (playerName);
CREATE INDEX index_pl_SEASON ON players (SEASON);
CREATE INDEX index_pl_team ON players (team);

drop index index_tm_team;
CREATE INDEX index_tm_team ON teams(team);

drop index index_gs_match_id;
drop index index_gs_home_team;
drop index index_gs_visit_team;
drop index index_gs_game_year;
CREATE INDEX index_gs_match_id ON gameScore(match_id);
CREATE INDEX index_gs_home_team ON gameScore(home_team);
CREATE INDEX index_gs_visit_team ON gameScore(visit_team);
CREATE INDEX index_gs_game_year ON gameScore(game_year);


drop index index_rpm_Player;
drop index index_rpm_year;
drop index index_rpm_tm;
drop index index_rpm_pos;
CREATE INDEX index_rpm_Player ON rpm(Player);
CREATE INDEX index_rpm_year ON rpm(year_);
CREATE INDEX index_rpm_tm ON rpm(Tm);
CREATE INDEX index_rpm_pos ON rpm(Pos);
