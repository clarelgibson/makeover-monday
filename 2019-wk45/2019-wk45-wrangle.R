# Title:       2019-wk45-wrangle
# Project:     Makeover Monday 2019 Week 45
# Date:        2021-11-03
# Author:      Clare Gibson

# SUMMARY ############################################################
# This script reads and cleans the data used for this project.
# Data source: https://www.lvcva.com/research/visitor-statistics/

# PACKAGES ###########################################################
library(tidyverse)
library(janitor)

# READ DATA ##########################################################
# Define the path where the data is located
path <- '2019-wk45/data/2019-wk45-data-through-sep-2021.csv'

# Read the data into a dataframe
df <- read_csv(path)

# CLEAN DATA #########################################################
# Clean the column names
df <- df %>% 
  clean_names()

# Inspect the df
glimpse(df)

# Convert the percentage columns from character to numeric
df <- df %>% 
  mutate(across(ends_with('_percentage'), parse_number),
         across(ends_with('_percentage'), ~ .x/100))

# Check it worked
glimpse(df)

# Calculate annualized values for sum columns for all years.
# Where months < 12 we will assume the average of available months
# for missing months.
# Apply to all columns expect year and _percentage columns.
# For the percentage columns we will assume that the YTD figures are
# indicative of the whole year.

# Look at the before state
df %>% 
  filter(year == 2021) %>% 
  glimpse()

# Apply the annualization calculation
df <- df %>% 
  mutate(across(!c(year, ends_with('_percentage')), ~(.x/months)*12))

# Check it worked
df %>% 
  filter(year == 2021) %>% 
  glimpse()

# EXPORT DATA ########################################################
# define file name
file <- '2019-wk45/data/2019-wk45-data-clean.csv'

write_csv(df,
          file=file,
          na="")