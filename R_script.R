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

# Lets view the dataset head
head(df, 5)
View(df)

# exploring the dataset
str(df)
colnames(df) # getting the column names in the dataframe
glimpse(df)
skim_without_charts(df)
