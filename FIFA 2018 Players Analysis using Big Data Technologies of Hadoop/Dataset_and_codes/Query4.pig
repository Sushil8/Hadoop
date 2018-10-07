attributes = LOAD 'attributes.csv' USING PigStorage(',') AS(acceleration:int, Aggression:int, Agility:int, Balance:int, Ball_control:int, Composure:int, Crossing:int, Curve:int, Dribbling:int, Finishing:int, Free_kick:int, GK_diving:int, GK_handling:int, GK_kicking:int, GK_positioning:int, GK_reflexes:int, Heading_accuracy:int, ID:int, Interceptions:int, Jumping:int, Long_passing:int, Long_shots:int, Marking:int, Penalties:int, Positioning:int, Reactions:int, Short_passing:int, Shot_power:int, Sliding_tackle:int, Sprint_speed:int, Stamina:int, Standing_tackle:int, Strength:int, Visions:int, Volleys:int);
--DUMP attributes;

positions = LOAD 'positions.csv' USING PigStorage(',') AS(cam:int, cb:int, cdm:int, cf:int, cm:int, ID:int, lam:int, lb:int, lcb:int, lcm:int, ldm:int, lf:int, lm:int, ls:int, lw:int, lwd:int, preferred:chararray, ram:int, rb:int, rcb:int , rcm:int, rdm:int, rf:int , rm:int , rs:int, rw:int, rwb:int, st:int);
--DUMP positions;

personal = LOAD 'personal.csv' USING PigStorage(',') AS(ID:int, Name:chararray, Age:int, Nationality:chararray, Overall:int, Potential:int, Club:chararray , Value:int, Wage:int , Special:int);
--DUMP personal;


filter_att = FILTER attributes BY (Aggression>75 AND Visions>75);
--DUMP filter_att;
player_att = FOREACH filter_att GENERATE ID, Aggression, Agility, Visions;
--DUMP player_att

filter_pos = FILTER positions BY (st>80 OR cam>80 OR cf >80 OR rw>80 OR lw>80 OR cb>80 OR lb>75 OR rb>70 OR cm>80);
--DUMP filter_pos;
player_pos = FOREACH filter_pos GENERATE ID, preferred, cf, cm, cb, st;
--DUMP player_pos;

filter_per = FILTER personal BY (Age<32);
--DUMP filter_per;
player_per = FOREACH filter_per GENERATE ID, Name, Overall, Potential, Special, Club, Nationality, Value;
--DUMP player_per;

playerdata = JOIN player_att by ID, player_pos by ID, player_per by ID;
--DUMP playerdata;

STORE playerdata into 'Query4' USING PigStorage(',');
