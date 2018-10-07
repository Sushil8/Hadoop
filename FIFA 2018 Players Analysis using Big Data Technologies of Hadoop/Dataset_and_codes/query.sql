SELECT name,club,age,aggression,agility,ball_control FROM personal inner join attributes on personal.id = attributes.id where (aggression>75 AND agility > 75) AND overall > 80
