# prerequisite
library(tidyverse)
library(ggthemes)

# First Steps
## The Penguins Data Frame

library(palmerpenguins)
data(penguins)

penguins
glimpse(penguins)

## Ultimate Goal

ggplot(data = penguins,
       mapping = aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point()

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g,
                     color = species)) +
  geom_point() +
  geom_smooth(method = "lm")


ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point(aes(color = species,
                 shape = species)) +
  geom_smooth(method = "lm")

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point(aes(color = species,
                 shape = species)) +
  geom_smooth(method = "lm") +
  labs(
    title = "Body mass and flipper length",
    subtitle = "Dimensions for Adelie, Chinstrap, and Gentoo Penguins",
    x = "Flipper length (mm",
    y = "Body mass (g)",
    color = "Species",
    shape = "Species"
  ) +
  scale_color_colorblind()

## ggplot2 Calls
ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point()

penguins |> 
  ggplot(aes(x = flipper_length_mm,
             y = body_mass_g)) +
  geom_point()

## Visualizing Distributions
### A Categorical Variable

ggplot(penguins, aes(x = species)) +
  geom_bar()

ggplot(penguins, aes(x = fct_infreq(species))) +
  geom_bar()

### A Numerical Variable

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 200)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 20)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_histogram(binwidth = 2000)

ggplot(penguins, aes(x = body_mass_g)) +
  geom_density()

### Exercises
#1
ggplot(penguins, aes(y = species)) +
  geom_bar()

ggplot(penguins, aes(y = fct_infreq(species))) +
  geom_bar()

#2
#3
#4
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

## Visualizing Relationships
### A Numerical and a Categorical Variable

ggplot(penguins, aes(x = species,
                     y = body_mass_g)) +
  geom_boxplot()

ggplot(penguins, aes(x = body_mass_g,
                     color = species)) +
  geom_density(linewidth = 0.75)

ggplot(penguins, aes(x = body_mass_g,
                     color = species,
                     fill = species)) +
  geom_density(alpha = 0.5)

## Two Categorical Variables

ggplot(penguins, aes(x = island,
                     fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island,
                     fill = species)) +
  geom_bar()

ggplot(penguins, aes(x = island,
                     fill = species)) +
  geom_bar(position = "fill")

## Two Numerical Variables

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point()

## Three or More Variables

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point(aes(color = species,
                 shape = island))

ggplot(penguins, aes(x = flipper_length_mm,
                     y = body_mass_g)) +
  geom_point(aes(color = species,
                 shape = species)) +
  facet_wrap(~island)

ggplot(
  data = penguins,
  mapping = aes(
    x = bill_length_mm, y = bill_depth_mm,
    color = species, shape = species
  )
) +
  geom_point() +
  labs(color = "Species",
       shape = "Species")

ggplot(penguins, aes(x = island, fill = species)) +
  geom_bar(position = "fill")
ggplot(penguins, aes(x = species, fill = island)) +
  geom_bar(position = "fill")

ggsave("penguin_plot.png")
