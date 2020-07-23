#----------------------------------------
# This script sets out to visualise
# ABS data on fertility rates smoothed
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 23 July 2020
#----------------------------------------

#------------------------DATA VISUALISATION------------

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
  
  the_plot <- data %>%
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

p <- pill_plot(d2, 1972, 210) +
  labs(subtitle = "Rate = births per 1,000 women. Each point is a 5-year age group in time.",
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.")
print(p)

p1 <- pill_plot(d3, 1968, 115) +
  labs(subtitle = "Rate = births per 1,000 women. Each point is the mean of 5-year age group fertility rates in time.",
       caption = "Source: ABS - Australian historical statistics.")
print(p1)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/age-smooth.png", 1000, 600)
print(p)
dev.off()

CairoPNG("output/mean-smooth.png", 1000, 600)
print(p1)
dev.off()
