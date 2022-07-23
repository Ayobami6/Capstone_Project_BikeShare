# Importing the packages 
library(tidyverse)
library(janitor)
library(skimr)
library(lubridate)
install.packages('usethis')
library(usethis) # importing usethis packages to store my git credentials 
use_usethis()
# Reading the dataset
df <- read.csv('E:/Alx-project3/202205-divvy-tripdata/202205-divvy-tripdata.csv')
df_copy <- df
# Lets view the dataset head
head(df, 5)
View(df)

# exploring the dataset
str(df)
colnames(df) # getting the column names in the dataframe
glimpse(df)
skim_without_charts(df)

# clean the data
# convert the started at and ended at to datetime
class(df$started_at)
sort(df$started_at)
tail(df)

str(df_copy)
# cleaning 
df_copy$start_date <- as.Date(df_copy$started_at) 
df_copy$start_month <- format(as.Date(df_copy$start_date), "%m")
df_copy$start_day <- format(as.Date(df_copy$start_date), "%d")
df_copy$start_year <- format(as.Date(df_copy$start_date), "%Y")
df_copy$start_week <- format(as.Date(df_copy$start_date), "%A")
df_copy$end_date <- as.Date(df_copy$ended_at)
# drop some columns 
colnames(df_copy)
df_copy <- df_copy %>% select(-c(start_lat, start_lng, end_lat, end_lng))
# Create new column for trip duration
df_copy$ride_duration <- difftime(df_copy$ended_at, df_copy$started_at)
str(df_copy)
skim_without_charts(df_copy)
# Seems I have negative ride duration, so lets remove that
df_clean <- filter(df_copy, df_copy$ride_duration >= 0)
# Lets save the clean dataframe 
write.csv(df_clean, "C:\\Users\\Ayo\\Desktop\\bike_share_data.csv")
#df_copy <- df_copy %>% select(-c(started_at, ended_at))


# Rename column names 
df_clean <- rename(df_clean, start_day_of_week=start_week)
summary(df_copy)
skim_without_charts(df_copy)
table(df_copy$member_casual)
df_clean$ride_duration <- as.numeric(df_clean$ride_duration)
is.numeric(df_clean$ride_duration)
# To understand the data well lets convert the trip duration in mins and have it a seperate column
df_clean$ride_duration_mins <- df_clean$ride_duration / 60

## Analysis 
summary(df_clean$ride_duration_mins)
aggregate(df_clean$ride_duration ~ df_clean$member_casual, FUN = mean)
aggregate(df_clean$ride_duration ~ df_clean$member_casual, FUN = median)
aggregate(df_clean$ride_duration ~ df_clean$member_casual, FUN = max)
aggregate(df_clean$ride_duration ~ df_clean$member_casual, FUN = min)
class(df_clean$ride_duration)
table(df_clean$member_casual)
#table(df_clean$start_station_name)
df_clean <- rename(df_clean, start_day_of_week=start_week)
aggregate(df_clean$ride_duration ~ df_clean$member_casual + df_clean$start_day_of_week, FUN = mean)

df_clean$start_day_of_week <- ordered(df_clean$start_day_of_week, levels=c('Sunday', 'Monday', 
                                                                           'Tuesday',
                                                                           'Wednessday', 'Thursday', 
                                                                           'Friday',
                                                                           'Saturday'))
aggregate(df_clean$ride_duration ~ df_clean$member_casual + df_clean$start_day_of_week, FUN = mean)

df_clean %>%
  mutate(weekday=wday(started_at, label=TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides =n(), average_duration = mean(ride_duration)) %>% 
  arrange(member_casual, weekday)

# Data Visualisation
library(ggplot2)
df_clean %>%
  mutate(weekday=wday(started_at, label=TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides =n(), average_duration = mean(ride_duration)) %>% 
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x=weekday, y=number_of_rides, fill=member_casual)) + geom_col(position = 'dodge')
ggsave('barchart.png', dpi=200)

df_clean %>%
  mutate(weekday=wday(started_at, label=TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides =n(), average_duration = mean(ride_duration)) %>% 
  arrange(member_casual, weekday) %>% 
  ggplot(aes(x=weekday, y=average_duration, fill=member_casual)) + geom_col(position = 'dodge')

