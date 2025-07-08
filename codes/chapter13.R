library(tidyverse)
library(nycflights13)

## Making Numbers

x <- c("1.2", "5.6", "1e3")
parse_double(x)

x <- c("1,234", "USD 3,513", "59%")
parse_number(x)
# parse_double(x) not working

## Counts

flights |> 
  count(dest)

flights |> 
  count(dest,
        sort = TRUE) |> 
  View()

flights |> 
  count(dest,
        sort = TRUE) |> 
  print(n = Inf)

flights |> 
  group_by(dest) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  )

flights |> 
  group_by(dest) |> 
  summarize(carriers = n_distinct(carrier)) |> 
  arrange(desc(carriers))

flights |> 
  group_by(tailnum) |> 
  summarize(miles = sum(distance))

flights |> 
  count(tailnum,
        wt = distance)

flights |> 
  group_by(dest) |> 
  summarize(n_cancelled = sum(is.na(dep_time)))

flights |> 
  mutate(na_dep = is.na(dep_time)) |> 
  count(na_dep)

flights |> 
  count(dest, sort = TRUE)

flights |> 
  count(tailnum, wt = distance)

## Numeric Transformation

### Arithmetic and Recycling Rules

x <- c(1, 2, 10, 20)
x / 5
x / c(5, 5, 5, 5)

x * c(1, 2)
x * c(1, 2, 3)

flights |> 
  filter(month == c(1, 2))

### Minimum and Maximum

df <- tribble(
  ~x, ~y,
  1, 3,
  5, 2,
  7, NA
)

df |> 
  mutate(
    min = pmin(x, y, na.rm = TRUE),
    max = pmax(x, y, na.rm = TRUE)
  )

df |>
  mutate(
    min = min(x, y, na.rm = TRUE),
    max = max(x, y, na.rm = TRUE)
  )

### Modular Arithmetic

1:10 %/% 3
1:10 %% 3

flights |> 
  mutate(
    hour = sched_dep_time %/% 100,
    minute = sched_dep_time %% 100,
    .keep = "used"
  )

flights |> 
  group_by(hour = sched_dep_time %/% 100) |> 
  summarize(prop_cancelled = mean(is.na(dep_time)), n = n()) |> 
  filter(hour > 1) |> 
  ggplot(aes(x = hour, y = prop_cancelled)) +
  geom_line(color = "grey50") +
  geom_point(aes(size = n))

### Rounding

round(123.456)

round(123.456, 2)
round(123.456, 1)
round(123.456, -1)
round(123.456, -2)

round(c(1.5, 2.5))

x <- 123.456

floor(x)
ceiling(x)

floor(x / 0.01) * 0.01
ceiling(x / 0.01) * 0.01

round(x / 4) * 4
round(x / 0.25) * 0.25

### Cutting Numbers into Ranges

x <- c(1, 2, 5, 10, 15, 20)
cut(x, breaks = c(0, 5, 10, 15, 20))

cut(x, breaks = c(0, 5, 10, 100))

cut(x, breaks = c(0, 5, 10, 15, 20),
    labels = c("sm", "md", "lg", "xl"))

y <- c(NA, -10, 5, 10, 30)
cut(y, breaks = c(0, 5, 10, 15, 20))

### Cumulative and Rolling Aggregates

x <- 1:10
cumsum(x)

### Exercises

flights |>
  filter(month == 1, day == 1) |>
  ggplot(aes(x = sched_dep_time, y = dep_delay)) +
  geom_point()

## General Transformations

### Ranks
x <- c(1, 2, 2, 3, 4, NA)
min_rank(x)

min_rank(desc(x))

df <- tibble(x = x)
df |> 
  mutate(
    row_number = row_number(x),
    dense_rank = dense_rank(x),
    percent_rank = percent_rank(x),
    cume_dist = cume_dist(x)
  )

df <- tibble(id = 1:10)

df |> 
  mutate(
    row0 = row_number() - 1,
    three_groups = row0 %% 3,
    three_in_each_group = row0 %/% 3
  )

### Offsets

x <- c(2, 5, 11, 11, 19, 35)
lag(x)
lead(x)

x == lag(x)

### Consecutive Identifiers

events <- tibble(
  time = c(0, 1, 2, 3, 5, 10, 12, 15, 17, 19, 20, 27, 28, 30)
)

events <- events |> 
  mutate(
    diff = time - lag(time, default = first(time)),
    has_gap = diff >= 5
  )
events

events |> mutate(group = cumsum(has_gap)
)

df <- tibble(
  x = c("a", "a", "a", "b", "c", "c", "d", "e", "a", "a", "b", "b"),
  y = c(1, 2, 3, 2, 4, 1, 3, 9, 4, 8, 10, 199)
)
df |> 
  group_by(consecutive_id(x)) |> 
  slice_head(n = 1)

### flights
flights |> 
  mutate(min_rank = min_rank(desc(dep_delay)),
         row_number = row_number(desc(dep_delay)),
         dense_rank = dense_rank(desc(dep_delay))) |> 
  filter(!(min_rank > 10 | row_number > 10 | dense_rank > 10)) |> 
  arrange(min_rank)

flights |> group_by(dest) |> filter(row_number() < 4)
flights |> group_by(dest) |> filter(row_number(dep_delay)
                                    < 4)

flights |> 
  filter(arr_delay > 0) |> 
  group_by(dest) |> 
  summarize(delay = sum(arr_delay, na.rm = TRUE))

flights |> 
  select(dest, arr_delay) |> 
  group_by(dest) |> 
  filter(arr_delay > 0) |> 
  mutate(total_delay = sum(arr_delay, na.rm = TRUE),
         prop_delay = arr_delay / total_delay)

## Numeric Summaries

### Center

flights |> 
  group_by(year, month, day) |> 
  summarize(
    mean = mean(dep_delay, na.rm = TRUE),
    median = median(dep_delay, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  ) |> 
  ggplot(aes(x = mean, y = median)) +
  geom_abline(slope = 1, intercept = 0, color = "white", linewidth = 2) +
  geom_point()

### Minimum, Maximum, and Quantiles

flights |> 
  group_by(year, month, day) |> 
  summarize(
    max = max(dep_delay, na.rm = TRUE),
    q95 = quantile(dep_delay, 0.95, na.rm = TRUE),
    .groups = "drop"
  )

### Spread

flights |> 
  group_by(origin, dest) |> 
  summarize(
    distance_sd = IQR(distance),
    n = n(),
    .groups = "drop"
  ) |> 
  filter(distance_sd > 0)

### Distributions

flights |> 
  filter(dep_delay < 120) |> 
  ggplot(aes(x = dep_delay, group = interaction(day, month))) +
  geom_freqpoly(binwidth = 5,
                alpha = 1/5)

## Positions
flights |> 
  group_by(year, month, day) |> 
  summarize(
    first_dep = first(dep_time, na_rm = TRUE),
    fifth_dep = nth(dep_time, 5, na_rm = TRUE),
    last_dep = last(dep_time, na_rm = TRUE)
  )

flights |> 
  group_by(year, month, day) |> 
  mutate(r = min_rank(sched_dep_time)) |> 
  filter(r %in% c(1, max(r)))
