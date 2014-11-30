drop table gameScore_rates;
create table gameScore_rates as
select
match_id,
game_year,
home_team,
home_team_score,
visit_team,
visit_team_score,
RPM_weight_0,
ORPM_weight_0,
DRPM_weight_0,
PER_weight_0,
RPM_weight_1,
ORPM_weight_1,
DRPM_weight_1,
PER_weight_1,
avg_scoreDiff,
avg_homeWin,
avg_scoreDiff_home,
avg_win_home,
avg_scoreDiff_visit,
avg_win_visit
from regTable_visit
;
