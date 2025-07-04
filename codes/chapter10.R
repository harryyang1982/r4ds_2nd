library(tidyverse)

## Variation

data(diamonds)
ggplot(diamonds, aes(x = carat)) +
  geom_histogram(binwidth = 0.5)

### Typical Values

smaller <- diamonds |> 
  filter(carat < 3)

ggplot(smaller, aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

### Unusual Values

ggplot(diamonds, aes(x = y)) +
  geom_histogram(binwidth = 0.5)

ggplot(diamonds, aes(x = y)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

unusual <- diamonds |> 
  filter(y < 3 | y > 20) |> 
  select(price, x, y, z) |> 
  arrange(y)

unusual

ggplot(diamonds, aes(x = x)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

ggplot(diamonds, aes(x = z)) +
  geom_histogram(binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 30))

## Unusual Values

# diamonds2 <- diamonds |> 
#   filter(between(y, 3, 20))

diamonds2 <- diamonds |> 
  mutate(y = case_when(y < 3 | y > 20 ~ NA,
                       TRUE ~ y))
diamonds2 |> 
  count(is.na(y))

ggplot(diamonds2, aes(x = x,
                      y = y)) +
  geom_point()

ggplot(diamonds2, aes(x = x,
                      y = y)) +
  geom_point(na.rm = TRUE)

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4)

nycflights13::flights |> 
  mutate(
    cancelled = is.na(dep_time),
    sched_hour = sched_dep_time %/% 100,
    sched_min = sched_dep_time %% 100,
    sched_dep_time = sched_hour + (sched_min / 60)
  ) |> 
  ggplot(aes(x = sched_dep_time)) +
  geom_freqpoly(aes(color = cancelled), binwidth = 1/4) +
  facet_wrap(~cancelled,
             scales = "free_y")

## Covariation
### A Categorical and a Numerical Variables

ggplot(diamonds, aes(x = price)) +
  geom_freqpoly(aes(color = cut), 
                binwidth = 500, 
                linewidth = 0.75)

ggplot(diamonds, aes(x = cut,
                     y = price)) +
  geom_boxplot()

ggplot(mpg, aes(x = class,
                y = hwy)) +
  geom_boxplot()

ggplot(mpg, aes(x = fct_reorder(class,
                                hwy,
                                median),
                y = hwy)) +
  geom_boxplot()

ggplot(mpg, aes(x = hwy,
                y = fct_reorder(class,
                                hwy,
                                median))) +
  geom_boxplot()

# nycflights13::flights |> 
#   mutate(
#     cancelled = is.na(dep_time),
#     sched_hour = sched_dep_time %/% 100,
#     sched_min = sched_dep_time %% 100,
#     sched_dep_time = sched_hour + (sched_min / 60)
#   ) |> 
#   ggplot(aes(y = sched_dep_time)) +
#   geom_boxplot(aes(color = cancelled))

### Two Categorical Variables
ggplot(diamonds, aes(x = cut,
                     y = color)) +
  geom_count()

diamonds |> 
  count(color, cut)

diamonds |> 
  count(color, cut) |> 
  ggplot(aes(x = color,
             y = cut)) +
  geom_tile(aes(fill = n ))

ggplot(diamonds, aes(x = color,
                     fill = cut)) +
  geom_bar()

### Two Numerical Variables
ggplot(smaller, aes(x = carat, y = price)) +
  geom_point()

ggplot(smaller, aes(x = carat, y = price)) +
  geom_point(alpha = 1 / 100)

ggplot(smaller, aes(x = carat,
                    y = price)) +
  geom_bin2d()

# install.packages("hexbin")
ggplot(smaller, aes(x = carat,
                    y = price)) +
  geom_hex()

# tidyverse_update()
ggplot(smaller, aes(x = carat,
                    y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 0.1)))

ggplot(smaller, aes(x = price,
                    y = carat)) +
  geom_boxplot(aes(group = cut_width(price, 1000)))

diamonds |>
  filter(x >= 4) |>
  ggplot(aes(x = x, y = y)) +
  geom_point() +
  coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

ggplot(smaller, aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_number(carat, 20)))

ggplot(smaller, aes(x = carat, y = price)) +
  geom_boxplot(aes(group = cut_width(carat, 20)))

## Patterns and Models
library(tidymodels)
diamonds <- diamonds |>
  mutate(
    log_price = log(price),
    log_carat = log(carat)
  )
diamonds_fit <- linear_reg() |>
  fit(log_price ~ log_carat, data = diamonds)
diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
  mutate(.resid = exp(.resid))
ggplot(diamonds_aug, aes(x = carat, y = .resid)) +
  geom_point()

ggplot(diamonds_aug, aes(x = cut,
                         y = .resid)) +
  geom_boxplot()
