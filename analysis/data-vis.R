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

# Define a vector of nice colours for each age group to use in plotting

the_palette <- c("15-19" = "#A0E7E5",
                 "20-24" = "#75E6DA",
                 "25-29" = "#189AB4",
                 "30-34" = "#05445E",
                 "35-39" = "#9571AB",
                 "40-44" = "#FD62AD",
                 "45-49" = "#F7C9B6")

#------------------------DATA VISUALISATION------------

# Density plot

p <- d1 %>%
  ggplot(aes(x = value)) +
  geom_density(fill = "#A0E7E5", colour = "#A0E7E5", alpha = 0.8) +
  labs(x = "Fertility Rate",
       y = "Density",
       title = "Distribution of Australian fertility rates by age group from 1921-2015",
       subtitle = "Rate = births per 1,000 women", 
       caption = "Source: ABS (2008) Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  facet_wrap(~age_group) +
  theme(panel.grid.minor = element_blank())
print(p)

# Time-series plot

p1 <- d1 %>%
  ggplot(aes(x = year, y = value)) +
  geom_line(aes(colour = age_group), size = 1.15) +
  labs(x = "Year",
       y = "Fertility Rate",
       title = "Time series of Australian fertility rates by age group from 1921-2015",
       subtitle = "Rate = births per 1,000 women",
       colour = "Age Group",
       caption = "Source: ABS (2008) Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  scale_colour_manual(values = the_palette) +
  theme(legend.position = "bottom")
print(p1)

# Pre and post-pill introduction plot

d2 <- d1 %>%
  mutate(pill = case_when(
    year < 1961 ~ "Pre-pill introduction",
    TRUE        ~ "Post-pill introduction")) %>%
  mutate(pill = factor(pill, levels = c("Pre-pill introduction", "Post-pill introduction")))

d3 <- d2 %>%
  group_by(year, pill) %>%
  summarise(value = mean(value)) %>%
  ungroup()

pill_plot <- function(data, x_width, y_height){
  
  p <- data %>%
    ggplot(aes(x = year, y = value)) +
    geom_smooth(aes(fill = pill, colour = pill), size = 1.15) +
    geom_point(aes(colour = pill)) +
    geom_vline(xintercept = 1961, show.legend = FALSE, lty = 2, size = 1, colour = "#05445E") +
    annotate("text", x = x_width, y = y_height, label = "Pill introduced in 1961", colour = "#05445E") +
    labs(x = "Year",
         y = "Fertility Rate",
         title = "Time series of Australian fertility rates from 1921-2015",
         colour = NULL) +
    theme_bw() +
    scale_colour_manual(values = c("#A0E7E5","#FD62AD")) +
    scale_fill_manual(values = c("#A0E7E5","#FD62AD"),
                      guide = FALSE) +
    theme(legend.position = "bottom") +
    guides(color = guide_legend(override.aes = list(fill = NA)))
}

p2 <- pill_plot(d2, 1972, 210) +
  labs(subtitle = "Rate = births per 1,000 women. Each point is a 5-year age group in time.",
       caption = "Source: ABS (2008) Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.")
print(p2)

p3 <- pill_plot(d3, 1968, 115) +
  labs(subtitle = "Rate = births per 1,000 women. Each point is the mean of 5-year age group fertility rates in time.",
       caption = "Source: ABS (2008) Australian historical statistics.")
print(p3)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/densities.png", 800, 800)
print(p)
dev.off()

CairoPNG("output/time-series.png", 1000, 600)
print(p1)
dev.off()

CairoPNG("output/age-smooth.png", 1000, 600)
print(p2)
dev.off()

CairoPNG("output/mean-smooth.png", 1000, 600)
print(p3)
dev.off()

