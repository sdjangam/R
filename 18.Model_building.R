#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)
library(modelr)
options(na.action = na.warn)
library(nycflights13)
library(lubridate)

#Why Are Low-Quality Diamonds More Expensive?
ggplot(diamonds, aes(cut, price)) + geom_boxplot()
ggplot(diamonds, aes(color, price)) + geom_boxplot()
ggplot(diamonds, aes(clarity, price)) + geom_boxplot()

#Price and Carat
ggplot(diamonds, aes(carat, price)) +
geom_hex(bins = 50)

diamonds2 <- diamonds %>%
filter(carat <= 2.5) %>%
mutate(lprice = log2(price), lcarat = log2(carat))

ggplot(diamonds2, aes(lcarat, lprice)) +
geom_hex(bins = 50)

mod_diamond <- lm(lprice ~ lcarat, data = diamonds2)

grid <- diamonds2 %>%
data_grid(carat = seq_range(carat, 20)) %>%
mutate(lcarat = log2(carat)) %>%
add_predictions(mod_diamond, "lprice") %>%
mutate(price = 2 ^ lprice)

ggplot(diamonds2, aes(carat, price)) +
geom_hex(bins = 50) +
geom_line(data = grid, color = "red", size = 1)

diamonds2 <- diamonds2 %>%
add_residuals(mod_diamond, "lresid")

ggplot(diamonds2, aes(lcarat, lresid)) +
geom_hex(bins = 50)

ggplot(diamonds2, aes(cut, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(color, lresid)) + geom_boxplot()
ggplot(diamonds2, aes(clarity, lresid)) + geom_boxplot()

#A More Complicated Model

mod_diamond2 <- lm(
lprice ~ lcarat + color + cut + clarity,
data = diamonds2
)

grid <- diamonds2 %>%
data_grid(cut, .model = mod_diamond2) %>%
add_predictions(mod_diamond2)
grid
#> # A tibble: 5 × 5
#> cut lcarat color clarity pred
#> <ord> <dbl> <chr> <chr> <dbl>
#> 1 Fair -0.515 G SI1 11.0
#> 2 Good -0.515 G SI1 11.1
#> 3 Very Good -0.515 G SI1 11.2
#> 4 Premium -0.515 G SI1 11.2
#> 5 Ideal -0.515 G SI1 11.2
ggplot(grid, aes(cut, pred)) +
geom_point()


diamonds2 <- diamonds2 %>%
add_residuals(mod_diamond2, "lresid2")

ggplot(diamonds2, aes(lcarat, lresid2)) +
geom_hex(bins = 50)

diamonds2 %>%
filter(abs(lresid2) > 1) %>%
add_predictions(mod_diamond2) %>%
mutate(pred = round(2 ^ pred)) %>%
select(price, pred, carat:table, x:z) %>%
arrange(price)
#> # A tibble: 16 × 11
#> price pred carat cut color clarity depth table x
#> <int> <dbl> <dbl> <ord> <ord> <ord> <dbl> <dbl> <dbl>
#> 1 1013 264 0.25 Fair F SI2 54.4 64 4.30
#> 2 1186 284 0.25 Premium G SI2 59.0 60 5.33
#> 3 1186 284 0.25 Premium G SI2 58.8 60 5.33
#> 4 1262 2644 1.03 Fair E I1 78.2 54 5.72
#> 5 1415 639 0.35 Fair G VS2 65.9 54 5.57
#> 6 1415 639 0.35 Fair G VS2 65.9 54 5.57
#> # ... with 10 more rows, and 2 more variables: y <dbl>,
#> # z <dbl>

#What Affects the Number of Daily Flights?

daily <- flights %>%
mutate(date = make_date(year, month, day)) %>%
group_by(date) %>%
summarize(n = n())
daily
#> # A tibble: 365 × 2
#> date n
#> <date> <int>
#> 1 2013-01-01 842
#> 2 2013-01-02 943
#> 3 2013-01-03 914
#> 4 2013-01-04 915
#> 5 2013-01-05 720
#> 6 2013-01-06 832
#> # ... with 359 more rows

ggplot(daily, aes(date, n)) +
geom_line()

#Day of Week

daily <- daily %>%
mutate(wday = wday(date, label = TRUE))
ggplot(daily, aes(wday, n)) +
geom_boxplot()

mod <- lm(n ~ wday, data = daily)

grid <- daily %>%
data_grid(wday) %>%
add_predictions(mod, "n")

ggplot(daily, aes(wday, n)) +
geom_boxplot() +
geom_point(data = grid, color = "red", size = 4)

daily <- daily %>%
add_residuals(mod)
daily %>%
ggplot(aes(date, resid)) +
geom_ref_line(h = 0) +
geom_line()

ggplot(daily, aes(date, resid, color = wday)) +
geom_ref_line(h = 0) +
geom_line()

daily %>%
filter(resid < -100)
#> # A tibble: 11 × 4
#> date n wday resid
#> <date> <int> <ord> <dbl>
#> 1 2013-01-01 842 Tues -109
#> 2 2013-01-20 786 Sun -105
#> 3 2013-05-26 729 Sun -162
#> 4 2013-07-04 737 Thurs -229
#> 5 2013-07-05 822 Fri -145
#> 6 2013-09-01 718 Sun -173
#> # ... with 5 more rows

daily %>%
ggplot(aes(date, resid)) +
geom_ref_line(h = 0) +
geom_line(color = "grey50") +
geom_smooth(se = FALSE, span = 0.20)
#> `geom_smooth()` using method = 'loess'

#Seasonal Saturday Effect

daily %>%
filter(wday == "Sat") %>%
ggplot(aes(date, n)) +
geom_point() +
geom_line() +
scale_x_date(
NULL,
date_breaks = "1 month",
date_labels = "%b"
)

term <- function(date) {
cut(date,
breaks = ymd(20130101, 20130605, 20130825, 20140101),
labels = c("spring", "summer", "fall")
)
}

daily <- daily %>%
mutate(term = term(date))

daily %>%
filter(wday == "Sat") %>%
ggplot(aes(date, n, color = term)) +
geom_point(alpha = 1/3) +
geom_line() +
scale_x_date(
NULL,
date_breaks = "1 month",
date_labels = "%b"
)

daily %>%
ggplot(aes(wday, n, color = term)) +
geom_boxplot()

mod1 <- lm(n ~ wday, data = daily)
mod2 <- lm(n ~ wday * term, data = daily)


daily %>%
gather_residuals(without_term = mod1, with_term = mod2) %>%
ggplot(aes(date, resid, color = model)) +
geom_line(alpha = 0.75)

grid <- daily %>%
data_grid(wday, term) %>%
add_predictions(mod2, "n")

ggplot(daily, aes(wday, n)) +
geom_boxplot() +
geom_point(data = grid, color = "red") +
facet_wrap(~ term)

mod3 <- MASS::rlm(n ~ wday * term, data = daily)


daily %>%
add_residuals(mod3, "resid") %>%
ggplot(aes(date, resid)) +
geom_hline(yintercept = 0, size = 2, color = "white") +
geom_line()

#Computed Variables

compute_vars <- function(data) {
data %>%
mutate(
term = term(date),
wday = wday(date, label = TRUE)
)
}

wday2 <- function(x) wday(x, label = TRUE)
mod3 <- lm(n ~ wday2(date) * term(date), data = daily)

#Time of Year: An Alternative Approach

library(splines)
mod <- MASS::rlm(n ~ wday * ns(date, 5), data = daily)

daily %>%
data_grid(wday, date = seq_range(date, n = 13)) %>%
add_predictions(mod) %>%
ggplot(aes(date, pred, color = wday)) +
geom_line() +
geom_point()

