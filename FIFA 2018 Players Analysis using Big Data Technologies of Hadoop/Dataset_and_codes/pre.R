setwd("/media/sf_PDA/fifa-18-demo-player-dataset/")
getwd()
players <- read.csv("PlayerAttributeData.csv", stringsAsFactors = FALSE)

#players <- players[,-c(5,13,14,16,95:185)]
players <- players[,-1]
sapply(players,function(x) sum(is.na(x)))
library(dplyr)
players_attr <- mutate_all(players, function(x) as.numeric(as.character(x)))
rm(players)
players_attr <- players_attr[!duplicated(players_attr$ID), ]
write.csv(players_attr, "attributes.csv", row.names = F, col.names = F)

players_pos <- read.csv("PlayerPlayingPositionData.csv", stringsAsFactors = FALSE)
players_pos <- players_pos[,-1]
sapply(players_pos,function(x) sum(is.na(x)))
players_pos <- na.omit(players_pos)
players_pos <- players_pos[!duplicated(players_pos$ID), ]
write.csv(players_pos, "positions.csv", row.names = F, col.names = F)

players_pers <- read.csv("PlayerPersonalData.csv", stringsAsFactors = FALSE, encoding = "UTF-8")
players_pers <- players_pers[,-c(1,2,6,8,12)]
sapply(players_pers,function(x) sum(is.na(x)))
players_pers$Value <- gsub("[^0-9]", "", players_pers$Value)

players_temp <- read.csv("/media/sf_PDA/fifa-18-more-complete-player-dataset/complete.csv")
players_pers$Value <- players_temp$eur_value[1:17929]
players_pers$Wage <- players_temp$eur_wage[1:17929]
rm(players_temp)
players_pers <- players_pers[!duplicated(players_pers$ID), ]
write.csv(players_pers, "personal.csv", row.names = F, col.names = F)