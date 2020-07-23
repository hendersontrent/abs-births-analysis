#----------------------------------------
# This script sets out to load all 
# things required for the project
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 23 July 2020
#----------------------------------------

# Load packages

library(tidyverse)
library(readxl)
library(janitor)
library(ggpubr)
library(Cairo)
library(scales)
library(forecast)
library(data.table)

# Read in data

d <- read_excel("data/fertility_data.xlsx", sheet = 1)

# Pre-process data into tidy format

d1 <- d %>%
  gather(key = year, value = value, 2:96) %>%
  clean_names() %>%
  mutate(age_group = gsub("\\(.*", "", age_group)) %>%
  mutate(year = as.numeric(year))

# Turn of scientific notation

options(scipen = 999)

# Define a vector of nice colours for each age group to use in plotting

the_palette <- c("15-19" = "#A0E7E5",
                 "20-24" = "#75E6DA",
                 "25-29" = "#189AB4",
                 "30-34" = "#05445E",
                 "35-39" = "#9571AB",
                 "40-44" = "#FD62AD",
                 "45-49" = "#F7C9B6")

# Create an output folder if none exists:

if(!dir.exists('output')) dir.create('output')
