#----------------------------------------
# This script sets out to visualise
# ABS data on fertility rates using
# density plots
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 23 July 2020
#----------------------------------------

#------------------------DATA VISUALISATION------------

# Faceted

p <- d1 %>%
  ggplot(aes(x = value)) +
  geom_density(fill = "#A0E7E5", colour = "#A0E7E5", alpha = 0.8) +
  labs(x = "Fertility Rate",
       y = "Density",
       title = "Distribution of Australian fertility rates by age group from 1921-2015",
       subtitle = "Rate = births per 1,000 women", 
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  facet_wrap(~age_group) +
  theme(panel.grid.minor = element_blank())
print(p)

# Single graph

p1 <- d1 %>%
  ggplot(aes(x = value)) +
  geom_density(aes(fill = age_group, colour = age_group), alpha = 0.4) +
  labs(x = "Fertility Rate",
       y = "Density",
       fill = NULL,
       colour = NULL,
       title = "Distribution of Australian fertility rates by age group from 1921-2015",
       subtitle = "Rate = births per 1,000 women", 
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  scale_colour_manual(values = the_palette,
                      guide = FALSE) +
  scale_fill_manual(values = the_palette) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank())
print(p1)

# Aggregated densities pre and post pill introduction

d2 <- d1 %>%
  mutate(pill = case_when(
    year < 1961 ~ "Pre-pill introduction",
    TRUE        ~ "Post-pill introduction")) %>%
  mutate(pill = factor(pill, levels = c("Pre-pill introduction", "Post-pill introduction")))

p2 <- d2 %>%
  ggplot(aes(x = value)) +
  geom_density(aes(fill = pill, colour = pill), alpha = 0.4) +
  labs(x = "Fertility Rate",
       y = "Density",
       fill = NULL,
       colour = NULL,
       title = "Distribution of Australian fertility rates from 1921-2015 by temporal position to pill introduction",
       subtitle = "Rate = births per 1,000 women", 
       caption = "Source: ABS - Australian historical statistics.") +
  theme_bw() +
  scale_colour_manual(values = c("#A0E7E5","#FD62AD"),
                      guide = FALSE) +
  scale_fill_manual(values = c("#A0E7E5","#FD62AD")) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank())
print(p2)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/density_facet.png", 800, 800)
print(p)
dev.off()

CairoPNG("output/density_single.png", 800, 800)
print(p1)
dev.off()

CairoPNG("output/density_pill.png", 800, 800)
print(p2)
dev.off()
