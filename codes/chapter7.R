library(tidyverse)

## Reading Data from a File

students <- read_csv("data/students.csv")
students
students <- read_csv("https://pos.it/r4ds-students-csv",
                     na = c("N/A", ""))

students |> 
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

students |> 
  janitor::clean_names()

students |> 
  janitor::clean_names() |> 
  mutate(meal_plan = factor(meal_plan))

students <- students |> 
  janitor::clean_names() |> 
  mutate(meal_plan = factor(meal_plan),
         age = parse_number(case_when(age == "five" ~ "5",
                                      TRUE ~ age)))

### Other Arguments
read_csv(
  "a, b, c
  1, 2, 3
  4, 5, 6"
)

read_csv(
  "The first line of metadata
The second line of metadata
x,y,z
1,2,3",
  skip = 2
)

read_csv(
  "# A comment I want to skip
x,y,z
1,2,3",
  comment = "#"
)

read_csv(
  "1,2,3
4,5,6",
  col_names = FALSE
)

read_csv(
  "1,2,3
4,5,6",
  col_names = c("x", "y", "z")
)

## Controlling Column Types

### Guessing Types

read_csv("
logical,numeric,date,string
TRUE,1,2021-01-15,abc
false,4.5,2021-02-15,def
T,Inf,2021-02-16,ghi
")
## Read_csv works because this is a simple case.

### Missing Values, Column Types, and Problems

simple_csv <- "
x
10
.
20
30"
simple_csv
read_csv(simple_csv)

df <- read_csv(
  simple_csv,
  col_types = list(x = col_double())
)
df
problems(df)

read_csv(simple_csv, na = ".")

another_csv <- "
x,y,z
1,2,3"

read_csv(
  another_csv,
  col_types = cols(.default = col_character())
)

read_csv(
  another_csv,
  col_types = cols_only(x = col_character())
)

## Reading Data from Multiple Files

sales_files <- c("data/01-sales.csv", "data/02-sales.csv", "data/03-sales.csv")
read_csv(sales_files, id = "file")

# sales_files <- c(
#   "https://pos.it/r4ds-01-sales",
#   "https://pos.it/r4ds-02-sales",
#   "https://pos.it/r4ds-03-sales"
# )
# read_csv(sales_files, id = "file")

# sales_files <- list.files("data", pattern = "sales\\.csv$", full.names = TRUE)
# sales_files

## Writing to a File

write_csv(students, "students.csv")
students
write_csv(students, "students-2.csv")
read_csv("students-2.csv")

write_rds(students, "data/students.rds")
read_rds("data/students.rds")

library(arrow)
write_parquet(students, "data/students.parquet")
read_parquet("students.parquet")

## Data Entry
tibble(
  x = c(1, 2, 5),
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)
