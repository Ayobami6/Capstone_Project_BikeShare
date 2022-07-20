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
df_copy <-df_copy %>% select(-c(days_of_week))
df_copy$ended_at <- as.Date(df_copy$ended_at)
df_copy$day_of_week <- factor(as.Date(df_copy$ended_at, '%A'))
df_copy$day <- factor(as.Date(df_copy$ended_at, "%d"))
str(df_copy)
df_copy %>% 
  mutate(weekday = wday(ended_at, label = TRUE))  #creates weekday field using wday()
df_copy$start_date <- as.Date(df_copy$started_at) #The default format is yyyy-mm-dd
df_copy$start_month <- format(as.Date(df_copy$start_date), "%m")
df_copy$start_day <- format(as.Date(df_copy$start_date), "%d")
df_copy$start_year <- format(as.Date(df_copy$start_date), "%Y")
df_copy$start_week <- format(as.Date(df_copy$start_date), "%A")
df_copy$end_date <- as.Date(df_copy$ended_at)
# drop some columns 
colnames(df_copy)
df_copy <- df_copy %>% select(-c(start_lat, start_lng, end_lat, end_lng))
df_copy <- df_copy %>% select(-c(started_at, ended_at))
# Rename column names 
df_copy <- rename(df_copy, start_day_of_week=start_week)
summary(df_copy)
skim_without_charts(df_copy)
table(df_copy$member_casual)
## Analysis 


