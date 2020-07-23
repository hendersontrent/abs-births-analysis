#----------------------------------------
# This script sets out to visualise
# ABS data on fertility rates by age 
# group
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 23 July 2020
#----------------------------------------

#------------------------DATA VISUALISATION------------

# Time-series plot

p <- d1 %>%
  ggplot(aes(x = year, y = value)) +
  geom_line(aes(colour = age_group), size = 1.15) +
  labs(x = "Year",
       y = "Fertility Rate",
       title = "Time series of Australian fertility rates by age group from 1921-2015",
       subtitle = "Rate = births per 1,000 women",
       colour = "Age Group",
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  scale_colour_manual(values = the_palette) +
  theme(legend.position = "bottom")
print(p)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/time-series.png", 1000, 600)
print(p)
dev.off()
