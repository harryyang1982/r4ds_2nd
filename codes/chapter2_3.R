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

