attributes = LOAD 'attributes.csv' USING PigStorage(',') AS(acceleration:int, Aggression:int, Agility:int, Balance:int, Ball_control:int, Composure:int, Crossing:int, Curve:int, Dribbling:int, Finishing:int, Free_kick:int, GK_diving:int, GK_handling:int, GK_kicking:int, GK_positioning:int, GK_reflexes:int, Heading_accuracy:int, ID:int, Interceptions:int, Jumping:int, Long_passing:int, Long_shots:int, Marking:int, Penalties:int, Positioning:int, Reactions:int, Short_passing:int, Shot_power:int, Sliding_tackle:int, Sprint_speed:int, Stamina:int, Standing_tackle:int, Strength:int, Visions:int, Volleys:int);
--DUMP attributes;

positions = LOAD 'positions.csv' USING PigStorage(',') AS(cam:int, cb:int, cdm:int, cf:int, cm:int, ID:int, lam:int, lb:int, lcb:int, lcm:int, ldm:int, lf:int, lm:int, ls:int, lw:int, lwd:int, preferred:chararray, ram:int, rb:int, rcb:int , rcm:int, rdm:int, rf:int , rm:int , rs:int, rw:int, rwb:int, st:int);
--DUMP positions;

personal = LOAD 'personal.csv' USING PigStorage(',') AS(ID:int, Name:chararray, Age:int, Nationality:chararray, Overall:int, Potential:int, Club:chararray , Value:int, Wage:int , Special:int);
--DUMP personal;

nameloo = FOREACH personal GENERATE ID,Name,Age,Overall,Club;

top_player = FILTER nameloo by Overall>85;
--dump top_player;

attr_loo = FOREACH attributes GENERATE ID,acceleration,Balance, Dribbling, Strength, Finishing;
playerdata = JOIN top_player by ID, attr_loo by ID;

club_group = GROUP playerdata by Club;
dump club_group;
STORE club_group into 'Query3' USING PigStorage(',');
