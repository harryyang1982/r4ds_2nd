library(tidyverse)

table1 |> 
  mutate(rate = cases / population * 10000)

table1 |> 
  group_by(year) |> 
  summarize(total_cases = sum(cases))

table1 |> 
  summarize(total_cases = sum(cases),
            .by = year)

ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

## Data in Column Names

billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  )

billboard_longer <- billboard |> 
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |> 
  mutate(
    week = parse_number(week)
  )

ggplot(billboard_longer, aes(x = week,
                             y = rank,
                             group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

# How Does Pivoting Work?

df <- tribble(
  ~id, ~bp1, ~bp2,
  "A", 100, 120,
  "B", 140, 115,
  "C", 120, 125
)

df
df |> 
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

## Many Variables in Column Names

who2

who2 |> 
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_",
    values_to = "count"
  )

## Data and Variable Names in the Column Headers

household

household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"),
    names_sep = "_",
    values_drop_na = TRUE)

# Widening Data

cms_patient_experience
data("cms_patient_experience")

cms_patient_experience |> 
  distinct(measure_cd, measure_title)

cms_patient_experience |> 
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

cms_patient_experience |> 
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

## How Does pivot_wider() Work?

df <- tribble(
  ~id, ~measurement, ~value,
  "A", "bp1", 100,
  "B", "bp1", 140,
  "B", "bp2", 115,
  "A", "bp2", 120,
  "A", "bp3", 105
)

df |> 
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |> 
  distinct(measurement) |> 
  pull()

df |> 
  select(-measurement, -value) |> 
  distinct()

df |> 
  select(-measurement, -value) |> 
  distinct() |> 
  mutate(x = NA, 
         y = NA,
         z = NA)

df <- tribble(
  ~id, ~measurement, ~value,
  "A", "bp1", 100,
  "A", "bp1", 102,
  "A", "bp2", 120,
  "B", "bp1", 140,
  "B", "bp2", 115
)
df

df |> 
  pivot_wider(
    names_from = measurement,
    value_from = value
  )

df |> 
  group_by(id, measurement) |> 
  summarize(n = n(),
            .groups = "drop") |> 
  filter(n > 1)
