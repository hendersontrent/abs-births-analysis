#----------------------------------------
# This script sets out to compute time
# series properties of the fertility
# data
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

# Compute autocorrelation function

acf_data <- d2 %>%
  group_by(age_group, pill) %>%
  nest() %>%
  mutate(acf_results = purrr::map(data, ~ acf(.x$value, plot = F)),
                acf_values = purrr::map(acf_results, ~ drop(.x$acf))) %>%
  unnest(acf_values) %>%
  group_by(age_group, pill) %>%
  mutate(lag = seq(0, n() - 1)) %>%
  ungroup()

# Plot it

p <- acf_data %>%
  ggplot(aes(x = acf_values)) +
  geom_density(aes(fill = pill, colour = pill), alpha = 0.6) +
  labs(x = "Autocorrelation Function Value",
       y = "Density",
       title = "Distribution of autocorrelation function values of 1921-2015 Australian fertility rates",
       subtitle = "Rate = births per 1,000 women",
       caption = "Source: ABS - Australian historical statistics. Age 15-19 includes ages <15 and 45-49 includes ages >49.",
       colour = NULL,
       fill = NULL) +
  theme_bw() +
  scale_colour_manual(values = c("#A0E7E5","#FD62AD"),
                      guide = FALSE) +
  scale_fill_manual(values = c("#A0E7E5","#FD62AD")) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank()) +
  facet_wrap(~age_group)
print(p)

#------------------------EXPORTS-----------------------

# Pull graphs into publishable figures and export

CairoPNG("output/density_acf.png", 800, 800)
print(p)
dev.off()
