library(tidyverse)
library(gridExtra)

# install.packages("gridExtra")
mpg

## Aesthetic Mappings

left_g <- ggplot(mpg, aes(x = displ,
                y = hwy,
                color = class)) +
  geom_point()

right_g <- ggplot(mpg, aes(x = displ,
                y = hwy,
                shape = class)) +
  geom_point()

grid.arrange(left_g, right_g, ncol = 2)

ggplot(mpg, aes(x = displ,
                y = hwy,
                size = class)) +
  geom_point()

ggplot(mpg, aes(x = displ,
                y = hwy,
                alpha = class)) +
  geom_point()

ggplot(mpg, aes(x = displ, 
                y = hwy)) +
  geom_point(color = "blue")

ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(stroke = hwy))

ggplot(mpg, aes(x = displ, 
                y = hwy,
                color = displ < 5)) +
  geom_point()

## Geometric Objects

# Left
grid_l <- ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point()

# Right

grid_r <- ggplot(mpg, aes(x = displ, 
                y = hwy)) +
  geom_smooth()

grid.arrange(grid_l,
             grid_r,
             ncol = 2)

# Left
grid2_l <- ggplot(mpg, aes(x = displ,
                y = hwy,
                shape = drv)) +
  geom_smooth()

# Right
grid2_r <- ggplot(mpg, aes(x = displ,
                y = hwy,
                linetype = drv)) +
  geom_smooth()

grid.arrange(grid2_l, grid2_r, ncol = 2)

ggplot(mpg, aes(x = displ,
                y = hwy,
                color = drv)) +
  geom_point() +
  geom_smooth(aes(linetype = drv))

# left
grid_l_1 <- ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_smooth()

# middle
grid_m_1 <- ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_smooth(aes(group = drv))

# right
grid_r_1 <- ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = FALSE)

grid.arrange(grid_l_1,
             grid_m_1,
             grid_r_1,
             ncol = 3)

ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  ) +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "red"
  )

# left
grid_l_2 <- ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

grid_m_2 <- ggplot(mpg, aes(x = hwy)) +
  geom_density()

grid_r_2 <- ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

grid.arrange(grid_l_2,
             grid_m_2,
             grid_r_2,
             ncol = 3)

# ggplot2 Extensions
library(ggridges)

ggplot(mpg, aes(x = hwy,
                y = drv,
                fill = drv,
                color = drv)) +
  geom_density_ridges(alpha = 0.5,
                      show.legend = FALSE)

## Facets
ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point() +
  facet_wrap(~cyl)

ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)

ggplot(mpg, aes(x = displ,
                y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl,
             scales = "free_y")

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

ggplot(mpg) +
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(~drv)

## Statistical Transformation

ggplot(diamonds, aes(x = cut)) +
  geom_bar()

diamonds |>
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")

ggplot(diamonds, aes(x = cut, 
                     y = after_stat(prop), 
                     group = 1)) +
  geom_bar()

ggplot(diamonds) +
  stat_summary(
    aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

# set group = 1
# ggplot(diamonds, aes(x = cut, y = after_stat(prop))) +
#   geom_bar()
# ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) +
#   geom_bar()

# Left
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(alpha = 1/5, position = "identity")
# Right
ggplot(mpg, aes(x = drv, color = class)) +
  geom_bar(fill = NA, position = "identity")

# Left
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "fill")
# Right
ggplot(mpg, aes(x = drv, fill = class)) +
  geom_bar(position = "dodge")

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "jitter")

ggplot(mpg, aes(x = cty, y = hwy)) +
  geom_point(position = "jitter")

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(position = "identity")

## Coordinate Systems

nz <- map_data("nz")

ggplot(nz, aes(x = long,
               y = lat,
               group = group)) +
  geom_polygon(fill = "white",
               color = "black")

ggplot(nz, aes(x = long,
               y = lat,
               group = group)) +
  geom_polygon(fill = "white",
               color = "black") +
  coord_quickmap()

world <- map_data("world")

ggplot(world, aes(x = long,
               y = lat,
               group = group)) +
  geom_polygon(fill = "white",
               color = "black")

ggplot(world, aes(x = long,
               y = lat,
               group = group)) +
  geom_polygon(fill = "white",
               color = "black") +
  coord_quickmap()

bar <- ggplot(data = diamonds) +
  geom_bar(
    aes(x = clarity,
        fill = clarity),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1)

bar + coord_flip()
bar + coord_polar()

ggplot(diamonds, aes(x = cut,
                     fill = cut)) +
  geom_bar(show.legend = FALSE,
           width = 1) +
  theme(aspect.ratio = 1) +
  coord_polar()

### Exercises
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() +
  coord_fixed()
