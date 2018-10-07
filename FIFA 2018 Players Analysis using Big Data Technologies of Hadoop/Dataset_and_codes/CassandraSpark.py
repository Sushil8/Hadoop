from pyspark.sql import SparkSession
from pyspark.sql import Row
from pyspark.sql import functions

def parseInput(line):
    fields = line.split(',')
    return Row(id = fields[0], name = fields[1], age = fields[2], nationality = fields[3], overall = fields[4], potential = fields[5], club = fields[6], value = fields[7], wage = fields[8], special = fields[9])

def parseInput1(line):
    fields = line.split(',')
    return Row(acceleration = fields[0], aggression = fields[1], agility=fields[2], balance=fields[3], ball_control=fields[4], composure=fields[5], crossing=fields[6], curve=fields[7], dribbling=fields[8], finishing=fields[9], free_kick=fields[10], gk_diving=fields[11], gk_handling=fields[12], gk_kicking=fields[13], gk_positioning=fields[14], gk_reflexes=fields[15], heading_accuracy=fields[16], id=fields[17], interceptions=fields[18], jumping=fields[19], long_passing=fields[20], long_shots=fields[21], marking=fields[22], penalties=fields[23], positioning=fields[24], reactions=fields[25], short_passing=fields[26], shot_power=fields[27], sliding_tackle=fields[28], sprint_speed=fields[29], stamina=fields[30], standing_tackle=fields[31], strength=fields[32], visions=fields[33], volleys=fields[34])

if __name__ == "__main__":

    spark = SparkSession.builder.appName("CassandraIntegration").config("spark.cassandra.connection.host", "127.0.0.1").getOrCreate()

    lines = spark.sparkContext.textFile("hdfs://localhost:54310/user/hduser/personal.csv")
    lines1 = spark.sparkContext.textFile("hdfs://localhost:54310/user/hduser/attributes.csv")

    users = lines.map(parseInput)
    users1 = lines1.map(parseInput1)
    usersDataset = spark.createDataFrame(users)
    usersDataset1 = spark.createDataFrame(users1)
    usersDataset.write\
        .format("org.apache.spark.sql.cassandra")\
        .mode('append')\
        .options(table="personal", keyspace="football")\
        .save()
    
    usersDataset1.write\
        .format("org.apache.spark.sql.cassandra")\
        .mode('append')\
        .options(table="attributes", keyspace="football")\
        .save()
    readUsers = spark.read\
    .format("org.apache.spark.sql.cassandra")\
    .options(table="personal", keyspace="football")\
    .load()

    readUsers.createOrReplaceTempView("personal")

    readUsers1 = spark.read\
    .format("org.apache.spark.sql.cassandra")\
    .options(table="attributes", keyspace="football")\
    .load()

    readUsers1.createOrReplaceTempView("attributes")
    sqlDF = spark.sql("SELECT name,club,age,aggression,agility,ball_control FROM personal inner join attributes on personal.id = attributes.id where (aggression>75 AND agility > 75) AND overall > 80")
    sqlDF.show()

    sqlDF.write\
        .format("org.apache.spark.sql.cassandra")\
        .mode('append')\
        .options(table="output", keyspace="football")\
        .save()

    spark.stop()
