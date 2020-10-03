#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)
library(modelr)
options(na.action = na.warn)

#A Simple Model
ggplot(sim1, aes(x, y)) +
geom_point()

models <- tibble(
a1 = runif(250, -20, 40),
a2 = runif(250, -5, 5)
)
ggplot(sim1, aes(x, y)) +
geom_abline(
aes(intercept = a1, slope = a2),
data = models, alpha = 1/4
) +
geom_point()

model1 <- function(a, data) {
a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1)
#> [1] 8.5 8.5 8.5 10.0 10.0 10.0 11.5 11.5 11.5 13.0 13.0
#> [12] 13.0 14.5 14.5 14.5 16.0 16.0 16.0 17.5 17.5 17.5 19.0
#> [23] 19.0 19.0 20.5 20.5 20.5 22.0 22.0 22.0

measure_distance <- function(mod, data) {
diff <- data$y - model1(mod, data)
sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)
#> [1] 2.67

sim1_dist <- function(a1, a2) {
measure_distance(c(a1, a2), sim1)
}
models <- models %>%
mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models
#> # A tibble: 250 × 3
#> a1 a2 dist
#> <dbl> <dbl> <dbl>
#> 1 -15.15 0.0889 30.8
#> 2 30.06 -0.8274 13.2
#> 3 16.05 2.2695 13.2
#> 4 -10.57 1.3769 18.7
#> 5 -19.56 -1.0359 41.8
#> 6 7.98 4.5948 19.3
#> # ... with 244 more rows

ggplot(sim1, aes(x, y)) +
geom_point(size = 2, color = "grey30") +
geom_abline(
aes(intercept = a1, slope = a2, color = -dist),
data = filter(models, rank(dist) <= 10)
)

ggplot(models, aes(a1, a2)) +
geom_point(
data = filter(models, rank(dist) <= 10),
size = 4, color = "red"
) +
geom_point(aes(colour = -dist))

grid <- expand.grid(
a1 = seq(-5, 20, length = 25),
a2 = seq(1, 3, length = 25)
) %>%
mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
grid %>%
ggplot(aes(a1, a2)) +
geom_point(
data = filter(grid, rank(dist) <= 10),
size = 4, colour = "red"
) +
geom_point(aes(color = -dist))

ggplot(sim1, aes(x, y)) +
geom_point(size = 2, color = "grey30") +
geom_abline(
aes(intercept = a1, slope = a2, color = -dist),
data = filter(grid, rank(dist) <= 10)
)

best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
#> [1] 4.22 2.05
ggplot(sim1, aes(x, y)) +
geom_point(size = 2, color = "grey30") +
geom_abline(intercept = best$par[1], slope = best$par[2])

sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
#> (Intercept) x
#> 4.22 2.05

#Visualizing Models
#Predictions

grid <- sim1 %>%
data_grid(x)
grid
#> # A tibble: 10 × 1
#> x
#> <int>
#> 1 1
#> 2 2
#> 3 3
#> 4 4
#> 5 5
#> 6 6
#> # ... with 4 more rows

grid <- grid %>%
add_predictions(sim1_mod)
grid
#> # A tibble: 10 × 2
#> x pred
#> <int> <dbl>
#> 1 1 6.27
#> 2 2 8.32
#> 3 3 10.38
#> 4 4 12.43
#> 5 5 14.48
#> 6 6 16.53
#> # ... with 4 more rows

ggplot(sim1, aes(x)) +
geom_point(aes(y = y)) +
geom_line(
aes(y = pred),
data = grid,
colour = "red",
size = 1
)

#Residuals
sim1 <- sim1 %>%
add_residuals(sim1_mod)
sim1
#> # A tibble: 30 × 3
#> x y resid
#> <int> <dbl> <dbl>
#> 1 1 4.20 -2.072
#> 2 1 7.51 1.238
#> 3 1 2.13 -4.147
#> 4 2 8.99 0.665
#> 5 2 10.24 1.919
#> 6 2 11.30 2.973
#> # ... with 24 more rows

ggplot(sim1, aes(resid)) +
geom_freqpoly(binwidth = 0.5)

ggplot(sim1, aes(x, resid)) +
geom_ref_line(h = 0) +
geom_point()

#Formulas and Model Families

df <- tribble(
~y, ~x1, ~x2,
4, 2, 5,
5, 1, 6
)
model_matrix(df, y ~ x1)
#> # A tibble: 2 × 2
#> `(Intercept)` x1
#> <dbl> <dbl>
#> 1 1 2
#> 2 1 1


model_matrix(df, y ~ x1 - 1)
#> # A tibble: 2 × 1
#> x1
#> <dbl>
#> 1 2
#> 2 1

model_matrix(df, y ~ x1 + x2)
#> # A tibble: 2 × 3
#> `(Intercept)` x1 x2
#> <dbl> <dbl> <dbl>
#> 1 1 2 5
#> 2 1 1 6

#Categorical Variables

df <- tribble(
~ sex, ~ response,
"male", 1,
"female", 2,
"male", 1
)
model_matrix(df, response ~ sex)
#> # A tibble: 3 × 2
#> `(Intercept)` sexmale
#> <dbl> <dbl>
#> 1 1 1
#> 2 1 0
#> 3 1 1

ggplot(sim2) +
geom_point(aes(x, y))

mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>%
data_grid(x) %>%
add_predictions(mod2)
grid
#> # A tibble: 4 × 2
#> x pred
#> <chr> <dbl>
#> 1 a 1.15
#> 2 b 8.12
#> 3 c 6.13
#> 4 d 1.91

ggplot(sim2, aes(x)) +
geom_point(aes(y = y)) +
geom_point(
data = grid,
aes(y = pred),
color = "red",
size = 4
)

tibble(x = "e") %>%
add_predictions(mod2)

#> Error in model.frame.default(Terms, newdata, na.action =
#> na.action, xlev = object$xlevels): factor x has new level e

#Interactions (Continuous and Categorical)

ggplot(sim3, aes(x1, y)) +
geom_point(aes(color = x2))


mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

grid <- sim3 %>%
data_grid(x1, x2) %>%
gather_predictions(mod1, mod2)
grid
#> # A tibble: 80 × 4
#> model x1 x2 pred
#> <chr> <int> <fctr> <dbl>
#> 1 mod1 1 a 1.67
#> 2 mod1 1 b 4.56
#> 3 mod1 1 c 6.48
#> 4 mod1 1 d 4.03
#> 5 mod1 2 a 1.48
#> 6 mod1 2 b 4.37
#> # ... with 74 more rows

ggplot(sim3, aes(x1, y, color = x2)) +
geom_point() +
geom_line(data = grid, aes(y = pred)) +
facet_wrap(~ model)

sim3 <- sim3 %>%
gather_residuals(mod1, mod2)
ggplot(sim3, aes(x1, resid, color = x2)) +
geom_point() +
facet_grid(model ~ x2)


#Interactions (Two Continuous)

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)
grid <- sim4 %>%
data_grid(
x1 = seq_range(x1, 5),
x2 = seq_range(x2, 5)
) %>%
gather_predictions(mod1, mod2)
grid
#> # A tibble: 50 × 4
#> model x1 x2 pred
#> <chr> <dbl> <dbl> <dbl>
#> 1 mod1 -1.0 -1.0 0.996
#> 2 mod1 -1.0 -0.5 -0.395
#> 3 mod1 -1.0 0.0 -1.786
#> 4 mod1 -1.0 0.5 -3.177
#> 5 mod1 -1.0 1.0 -4.569
#> 6 mod1 -0.5 -1.0 1.907
#> # ... with 44 more rows

seq_range(c(0.0123, 0.923423), n = 5)
#> [1] 0.0123 0.2401 0.4679 0.6956 0.9234
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)
#> [1] 0.0 0.2 0.4 0.6 0.8 1.0

x1 <- rcauchy(100)
seq_range(x1, n = 5)
#> [1] -115.9 -83.5 -51.2 -18.8 13.5
seq_range(x1, n = 5, trim = 0.10)
#> [1] -13.84 -8.71 -3.58 1.55 6.68
seq_range(x1, n = 5, trim = 0.25)
#> [1] -2.1735 -1.0594 0.0547 1.1687 2.2828
seq_range(x1, n = 5, trim = 0.50)
#> [1] -0.725 -0.268 0.189 0.647 1.104

x2 <- c(0, 1)
seq_range(x2, n = 5)
#> [1] 0.00 0.25 0.50 0.75 1.00

seq_range(x2, n = 5, expand = 0.10)
#> [1] -0.050 0.225 0.500 0.775 1.050
seq_range(x2, n = 5, expand = 0.25)
#> [1] -0.125 0.188 0.500 0.812 1.125
seq_range(x2, n = 5, expand = 0.50)
#> [1] -0.250 0.125 0.500 0.875 1.250

ggplot(grid, aes(x1, x2)) +
geom_tile(aes(fill = pred)) +
facet_wrap(~ model)

ggplot(grid, aes(x1, pred, color = x2, group = x2)) +
geom_line() +
facet_wrap(~ model)
ggplot(grid, aes(x2, pred, color = x1, group = x1)) +
geom_line() +
facet_wrap(~ model)

#Transformations

df <- tribble(
~y, ~x,
1, 1,
2, 2,
3, 3
)
model_matrix(df, y ~ x^2 + x)
#> # A tibble: 3 × 2
#> `(Intercept)` x
#> <dbl> <dbl>
#> 1 1 1
#> 2 1 2
#> 3 1 3
model_matrix(df, y ~ I(x^2) + x)
#> # A tibble: 3 × 3
#> `(Intercept)` `I(x^2)` x
#> <dbl> <dbl> <dbl>
#> 1 1 1 1
#> 2 1 4 2
#> 3 1 9 3

model_matrix(df, y ~ poly(x, 2))
#> # A tibble: 3 × 3
#> `(Intercept)` `poly(x, 2)1` `poly(x, 2)2`
#> <dbl> <dbl> <dbl>
#> 1 1 -7.07e-01 0.408
#> 2 1 -7.85e-17 -0.816
#> 3 1 7.07e-01 0.408

library(splines)
model_matrix(df, y ~ ns(x, 2))
#> # A tibble: 3 × 3
#> `(Intercept)` `ns(x, 2)1` `ns(x, 2)2`
#> <dbl> <dbl> <dbl>
#> 1 1 0.000 0.000
#> 2 1 0.566 -0.211
#> 3 1 0.344 0.771

sim5 <- tibble(
x = seq(0, 3.5 * pi, length = 50),
y = 4 * sin(x) + rnorm(length(x))
)
ggplot(sim5, aes(x, y)) +
geom_point()

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)
grid <- sim5 %>%
data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>%
gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")
ggplot(sim5, aes(x, y)) +
geom_point() +
geom_line(data = grid, color = "red") +
facet_wrap(~ model)

#Missing Values

df <- tribble(
~x, ~y,
1, 2.2,
2, NA,
3, 3.5,
4, 8.3,
NA, 10
)

mod <- lm(y ~ x, data = df)
#> Warning: Dropping 2 rows with missing values

mod <- lm(y ~ x, data = df, na.action = na.exclude)

nobs(mod)
#> [1] 3



