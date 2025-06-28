# sin(pi / 2)
# 
# seq(from = 1, 
#     to = 10)
# 
# seq(1, 10)
# 
# rep(1, 10)
# rep(seq(1, 5), each = 10)

# Chapter 3
library(nycflights13)
library(tidyverse)

## nycflights13
flights
glimpse(flights)
data(flights)

## dplyr Basics

flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    arr_delay = mean(arr_delay,
                     na.rm = TRUE)
  )

## Rows
### filter()

flights |> 
  filter(dep_delay > 120)

flights |> 
  filter(month == 1 & day == 1)

flights |> 
  filter(month == 1 | month == 2)

flights |> 
  filter(month %in% c(1, 2))

jan1 <- flights |> 
  filter(month == 1 & day == 1)

## arrange()

flights |> 
  arrange(year, month, day, dep_time)

flights |> 
  arrange(desc(dep_delay))

flights |> 
  arrange(-dep_delay)

## distinct()

flights |> 
  distinct()

flights |> 
  distinct(origin, dest)

flights |> 
  distinct(origin, dest,
           .keep_all = TRUE)

flights |> 
  count(origin, dest, sort = TRUE)

flights |> 
  filter(arr_delay >= 120,
         carrier %in% c("UA", "AA", "DL"),
         month %in% c(7, 8, 9),
         dep_delay <= 0)

flights |> 
  arrange(air_time) |> 
  select(air_time)

## Columns
### mutate()

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .before = 1
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .after = day
  )

flights |> 
  mutate(
    gain = dep_delay - arr_delay,
    speed = distance / air_time * 60,
    .keep = "used"
  )

flights |> 
  select(tail_num = tailnum)

flights |> 
  rename(tail_num = tailnum)

flights |> 
  relocate(time_hour, air_time)

flights |> 
  relocate(year:dep_time, .after = time_hour)
flights |> 
  relocate(starts_with("arr"), .before = dep_time)

variables <- c("year", "month", "day", "dep_delay", "arr_delay")

flights |> 
  select(any_of(variables))

flights |> 
  select(contains("TIME"))

flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

## group_by()
flights |> 
  group_by(month) |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    n = n()
  )

flights |> 
  slice_head(n = 1)

flights |> 
  slice_tail(n = 10)

flights |> 
  slice_max(dep_delay, n = 1)

flights |> 
  slice_min(dep_delay, n = 1)

flights |> 
  slice_sample(n = 1)

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1) |> 
  relocate(dest)

# flights |> 
#   slice_min(arr_delay, n = -1)

flights |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1,
            with_ties = FALSE) |> 
  relocate(dest)

### Grouping by Multiple variables

daily <- flights |> 
  group_by(year, month, day)
daily

daily_flights <- daily |> 
  summarize(n = n())

daily_flights <- daily |> 
  summarize(
    n = n(),
    .groups = "drop_last"
  )

daily_flights

### Ungrouping
daily |> 
  ungroup()

daily |> 
  ungroup() |> 
  summarize(
    avg_delay = mean(dep_delay, na.rm = TRUE),
    flights = n()
  )

### .by
flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = month
  )

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE),
    n = n(),
    .by = c(origin, dest)
  )

## Case Study: Aggregates and Sample Size

batters <- Lahman::Batting |> 
  group_by(playerID) |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE)
  )

batters2 <- Lahman::Batting |> 
  summarize(
    performance = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    n = sum(AB, na.rm = TRUE),
    .by = playerID
  )

identical(batters, batters2)

# batters
# batters2

batters |> 
  filter(n > 100) |> 
  ggplot(aes(x = n,
             y = performance)) +
  geom_point(alpha = 1/ 10) +
  geom_smooth(se = FALSE)

batters2 |> 
  filter(n > 100) |> 
  ggplot(aes(x = n,
             y = performance)) +
  geom_point(alpha = 1/ 10) +
  geom_smooth(se = FALSE)

batters |> 
  arrange(desc(performance))
