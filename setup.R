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

# Create an output folder if none exists:

if(!dir.exists('output')) dir.create('output')
