#----------------------------------------
# This script sets out to produce a box
# and whisker plot
#
# NOTE: This script requires setup.R to
# have been run first
#----------------------------------------

#----------------------------------------
# Author: Trent Henderson, 23 July 2020
#----------------------------------------

# Add pill indicator

d2 <- d1 %>%
  mutate(pill = case_when(
    year < 1961 ~ "Pre-pill introduction",
    TRUE        ~ "Post-pill introduction")) %>%
  mutate(pill = factor(pill, levels = c("Pre-pill introduction", "Post-pill introduction")))

p <- d2 %>%
  ggplot(aes(x = pill, y = value)) +
  geom_boxplot(aes(colour = pill)) +
  labs(x = NULL,
       y = "Fertility Rate",
       colour = NULL,
       title = "Spread of Australian fertility rates from 1921-2015 by age group and temporal positioning to pill introduction",
       subtitle = "Rate = births per 1,000 women", 
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.") +
  theme_bw() +
  facet_wrap(~age_group) +
  scale_colour_manual(values = c("#A0E7E5","#FD62AD")) +
  theme(legend.position = "none",
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank())
print(p)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/boxplots.png", 800, 800)
print(p)
dev.off()
