#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(modelr)
library(tidyverse)

library(gapminder)
gapminder

gapminder %>%
ggplot(aes(year, lifeExp, group = country)) +
geom_line(alpha = 1/3)

nz <- filter(gapminder, country == "New Zealand")
nz %>%
ggplot(aes(year, lifeExp)) +
geom_line() +
ggtitle("Full data = ")
nz_mod <- lm(lifeExp ~ year, data = nz)
nz %>%
add_predictions(nz_mod) %>%
ggplot(aes(year, pred)) +
geom_line() +
ggtitle("Linear trend + ")
nz %>%
add_residuals(nz_mod) %>%
ggplot(aes(year, resid)) +
geom_hline(yintercept = 0, color = "white", size = 3) +
geom_line() +
ggtitle("Remaining pattern")

#Nested Data

by_country <- gapminder %>%
group_by(country, continent) %>%
nest()
by_country
#> # A tibble: 142 × 3
#> country continent data
#> <fctr> <fctr> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]>
#> 2 Albania Europe <tibble [12 × 4]>
#> 3 Algeria Africa <tibble [12 × 4]>
#> 4 Angola Africa <tibble [12 × 4]>
#> 5 Argentina Americas <tibble [12 × 4]>
#> 6 Australia Oceania <tibble [12 × 4]>
#> # ... with 136 more rows

by_country$data[[1]]
#> # A tibble: 12 × 4
#> year lifeExp pop gdpPercap
#> <int> <dbl> <int> <dbl>
#> 1 1952 28.8 8425333 779
#> 2 1957 30.3 9240934 821
#> 3 1962 32.0 10267083 853
#> 4 1967 34.0 11537966 836
#> 5 1972 36.1 13079460 740
#> 6 1977 38.4 14880372 786
#> # ... with 6 more rows

#List-Columns

country_model <- function(df) {
lm(lifeExp ~ year, data = df)
}

models <- map(by_country$data, country_model)

by_country <- by_country %>%
mutate(model = map(data, country_model))
by_country
#> # A tibble: 142 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 4 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 5 Argentina Americas <tibble [12 × 4]> <S3: lm>
#> 6 Australia Oceania <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows

by_country %>%
filter(continent == "Europe")
#> # A tibble: 30 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 2 Austria Europe <tibble [12 × 4]> <S3: lm>
#> 3 Belgium Europe <tibble [12 × 4]> <S3: lm>
#> 4 Bosnia and Herzegovina Europe <tibble [12 × 4]> <S3: lm>
#> 5 Bulgaria Europe <tibble [12 × 4]> <S3: lm>
#> 6 Croatia Europe <tibble [12 × 4]> <S3: lm>
#> # ... with 24 more rows
by_country %>%
arrange(continent, country)
#> #A tibble: 142 × 4
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 2 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 3 Benin Africa <tibble [12 × 4]> <S3: lm>
#> 4 Botswana Africa <tibble [12 × 4]> <S3: lm>
#> 5 Burkina Faso Africa <tibble [12 × 4]> <S3: lm>
#> 6 Burundi Africa <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows

#Unnesting

by_country <- by_country %>%
mutate(
resids = map2(data, model, add_residuals)
)
by_country
#> # A tibble: 142 × 5
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 4 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 5 Argentina Americas <tibble [12 × 4]> <S3: lm>
#> 6 Australia Oceania <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows, and 1 more variable:
#> # resids <list>

resids <- unnest(by_country, resids)
resids
#> # A tibble: 1,704 × 7
#> country continent year lifeExp pop gdpPercap
#> <fctr> <fctr> <int> <dbl> <int> <dbl>
#> 1 Afghanistan Asia 1952 28.8 8425333 779
#> 2 Afghanistan Asia 1957 30.3 9240934 821
#> 3 Afghanistan Asia 1962 32.0 10267083 853
#> 4 Afghanistan Asia 1967 34.0 11537966 836
#> 5 Afghanistan Asia 1972 36.1 13079460 740
#> 6 Afghanistan Asia 1977 38.4 14880372 786
#> # ... with 1,698 more rows, and 1 more variable: resid <dbl>

resids %>%
ggplot(aes(year, resid)) +
geom_line(aes(group = country), alpha = 1 / 3) +
geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'gam'

resids %>%
ggplot(aes(year, resid, group = country)) +
geom_line(alpha = 1 / 3) +
facet_wrap(~continent)

#Model Quality

broom::glance(nz_mod)
#> r.squared adj.r.squared sigma statistic p.value df logLik
#> AIC BIC
#> 1 0.954 0.949 0.804 205 5.41e-08 2 -13.3
#> 32.6 34.1
#> deviance df.residual
#> 1 6.47 10

by_country %>%
mutate(glance = map(model, broom::glance)) %>%
unnest(glance)
#> # A tibble: 142 × 16
#> country continent data model
#> <fctr> <fctr> <list> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]> <S3: lm>
#> 2 Albania Europe <tibble [12 × 4]> <S3: lm>
#> 3 Algeria Africa <tibble [12 × 4]> <S3: lm>
#> 4 Angola Africa <tibble [12 × 4]> <S3: lm>
#> 5 Argentina Americas <tibble [12 × 4]> <S3: lm>
#> 6 Australia Oceania <tibble [12 × 4]> <S3: lm>
#> # ... with 136 more rows, and 12 more variables:
#> # resids <list>, r.squared <dbl>, adj.r.squared <dbl>,
#> # sigma <dbl>, statistic <dbl>, p.value <dbl>, df <int>,
#> # logLik <dbl>, AIC <dbl>, BIC <dbl>, deviance <dbl>,
#> # df.residual <int>

glance <- by_country %>%
mutate(glance = map(model, broom::glance)) %>%
unnest(glance, .drop = TRUE)
glance
#> # A tibble: 142 × 13
#> country continent r.squared adj.r.squared sigma
#> <fctr> <fctr> <dbl> <dbl> <dbl>
#> 1 Afghanistan Asia 0.948 0.942 1.223
#> 2 Albania Europe 0.911 0.902 1.983
#> 3 Algeria Africa 0.985 0.984 1.323
#> 4 Angola Africa 0.888 0.877 1.407
#> 5 Argentina Americas 0.996 0.995 0.292
#> 6 Australia Oceania 0.980 0.978 0.621
#> # ... with 136 more rows, and 8 more variables:
#> # statistic <dbl>, p.value <dbl>, df <int>, logLik <dbl>,
#> # AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>

glance %>%
arrange(r.squared)
#> # A tibble: 142 × 13
#> country continent r.squared adj.r.squared sigma
#> <fctr> <fctr> <dbl> <dbl> <dbl>
#> 1 Rwanda Africa 0.0172 -0.08112 6.56
#> 2 Botswana Africa 0.0340 -0.06257 6.11
#> 3 Zimbabwe Africa 0.0562 -0.03814 7.21
#> 4 Zambia Africa 0.0598 -0.03418 4.53
#> 5 Swaziland Africa 0.0682 -0.02497 6.64
#> 6 Lesotho Africa 0.0849 -0.00666 5.93
#> # ... with 136 more rows, and 8 more variables:
#> # statistic <dbl>, p.value <dbl>, df <int>, logLik <dbl>,
#> # AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>

glance %>%
ggplot(aes(continent, r.squared)) +
geom_jitter(width = 0.5)

bad_fit <- filter(glance, r.squared < 0.25)

gapminder %>%
semi_join(bad_fit, by = "country") %>%
ggplot(aes(year, lifeExp, color = country)) +
geom_line()


#List-Columns

data.frame(x = list(1:3, 3:5))
#> x.1.3 x.3.5
#> 1 1 3
#> 2 2 4
#> 3 3 5


data.frame(
x = I(list(1:3, 3:5)),
y = c("1, 2", "3, 4, 5")
)
#> x y
#> 1 1, 2, 3 1, 2
#> 2 3, 4, 5 3, 4, 5

tibble(
x = list(1:3, 3:5),
y = c("1, 2", "3, 4, 5")
)
#> # A tibble: 2 × 2
#> x y
#> <list> <chr>
#> 1 <int [3]> 1, 2
#> 2 <int [3]> 3, 4, 5

tribble(
~x, ~y,
1:3, "1, 2",
3:5, "3, 4, 5"
)
#> # A tibble: 2 × 2
#> x y
#> <list> <chr>
#> 1 <int [3]> 1, 2
#> 2 <int [3]> 3, 4, 5

#Creating List-Columns

#With Nesting

gapminder %>%
group_by(country, continent) %>%
nest()
#> # A tibble: 142 × 3
#> country continent data
#> <fctr> <fctr> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]>
#> 2 Albania Europe <tibble [12 × 4]>
#> 3 Algeria Africa <tibble [12 × 4]>

#> 4 Angola Africa <tibble [12 × 4]>
#> 5 Argentina Americas <tibble [12 × 4]>
#> 6 Australia Oceania <tibble [12 × 4]>
#> # ... with 136 more rows

gapminder %>%
nest(year:gdpPercap)
#> # A tibble: 142 × 3
#> country continent data
#> <fctr> <fctr> <list>
#> 1 Afghanistan Asia <tibble [12 × 4]>
#> 2 Albania Europe <tibble [12 × 4]>
#> 3 Algeria Africa <tibble [12 × 4]>
#> 4 Angola Africa <tibble [12 × 4]>
#> 5 Argentina Americas <tibble [12 × 4]>
#> 6 Australia Oceania <tibble [12 × 4]>
#> # ... with 136 more rows

#From Vectorized Functions

df <- tribble(
~x1,
"a,b,c",
"d,e,f,g"
)
df %>%
mutate(x2 = stringr::str_split(x1, ","))
#> # A tibble: 2 × 2
#> x1 x2
#> <chr> <list>
#> 1 a,b,c <chr [3]>
#> 2 d,e,f,g <chr [4]>

df %>%
mutate(x2 = stringr::str_split(x1, ",")) %>%
unnest()
#> # A tibble: 7 × 2
#> x1 x2
#> <chr> <chr>
#> 1 a,b,c a
#> 2 a,b,c b
#> 3 a,b,c c
#> 4 d,e,f,g d
#> 5 d,e,f,g e
#> 6 d,e,f,g f
#> # ... with 1 more rows

sim <- tribble(
~f, ~params,
"runif", list(min = -1, max = -1),
"rnorm", list(sd = 5),
"rpois", list(lambda = 10)
)
sim %>%
mutate(sims = invoke_map(f, params, n = 10))
#> # A tibble: 3 × 3
#> f params sims
#> <chr> <list> <list>
#> 1 runif <list [2]> <dbl [10]>
#> 2 rnorm <list [1]> <dbl [10]>
#> 3 rpois <list [1]> <int [10]>

#From Multivalued Summaries

mtcars %>%
group_by(cyl) %>%
summarize(q = quantile(mpg))
#> Error in eval(expr, envir, enclos): expecting a single value


mtcars %>%
group_by(cyl) %>%
summarize(q = list(quantile(mpg)))
#> # A tibble: 3 × 2
#> cyl q
#> <dbl> <list>
#> 1 4 <dbl [5]>
#> 2 6 <dbl [5]>
#> 3 8 <dbl [5]>

probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)
mtcars %>%
group_by(cyl) %>%
summarize(p = list(probs), q = list(quantile(mpg, probs))) %>%
unnest()
#> # A tibble: 15 × 3
#> cyl p q
#> <dbl> <dbl> <dbl>
#> 1 4 0.01 21.4
#> 2 4 0.25 22.8
#> 3 4 0.50 26.0
#> 4 4 0.75 30.4
#> 5 4 0.99 33.8
#> 6 6 0.01 17.8
#> # ... with 9 more rows


#From a Named List

x <- list(
a = 1:5,
b = 3:4,
c = 5:6
)

df <- enframe(x)
df
#> # A tibble: 3 × 2
#> name value
#> <chr> <list>
#> 1 a <int [5]>
#> 2 b <int [2]>
#> 3 c <int [2]>

df %>%
mutate(
smry = map2_chr(
name,
value,
~ stringr::str_c(.x, ": ", .y[1])
)
)
#> # A tibble: 3 × 3
#> name value smry
#> <chr> <list> <chr>
#> 1 a <int [5]> a: 1
#> 2 b <int [2]> b: 3
#> 3 c <int [2]> c: 5

#Simplifying List-Columns

#List to Vector

df <- tribble(
~x,
letters[1:5],
1:3,
runif(5)
)

df %>% mutate(
type = map_chr(x, typeof),
length = map_int(x, length)
)
#> # A tibble: 3 × 3
#> x type length
#> <list> <chr> <int>
#> 1 <chr [5]> character 5
#> 2 <int [3]> integer 3
#> 3 <dbl [5]> double 5

df <- tribble(
~x,
list(a = 1, b = 2),
list(a = 2, c = 4)
)
df %>% mutate(
a = map_dbl(x, "a"),
b = map_dbl(x, "b", .null = NA_real_)
)
#> # A tibble: 2 × 3
#> x a b
#> <list> <dbl> <dbl>
#> 1 <list [2]> 1 2
#> 2 <list [2]> 2 NA


#Unnesting

tibble(x = 1:2, y = list(1:4, 1)) %>% unnest(y)
#> # A tibble: 5 × 2
#> x y
#> <int> <dbl>
#> 1 1 1
#> 2 1 2
#> 3 1 3
#> 4 1 4
#> 5 2 1

# Ok, because y and z have the same number of elements in
# every row
df1 <- tribble(
~x, ~y, ~z,
1, c("a", "b"), 1:2,
2, "c", 3
)
df1
#> # A tibble: 2 × 3
#> x y z
#> <dbl> <list> <list>
#> 1 1 <chr [2]> <int [2]>
#> 2 2 <chr [1]> <dbl [1]>
df1 %>% unnest(y, z)
#> # A tibble: 3 × 3
#> x y z
#> <dbl> <chr> <dbl>
#> 1 1 a 1
#> 2 1 b 2
#> 3 2 c 3

# Doesn't work because y and z have different number of elements
df2 <- tribble(
~x, ~y, ~z,
1, "a", 1:2,
2, c("b", "c"), 3
)
df2
#> # A tibble: 2 × 3
#> x y z
#> <dbl> <list> <list>
#> 1 1 <chr [1]> <int [2]>
#> 2 2 <chr [2]> <dbl [1]>
df2 %>% unnest(y, z)
#> Error: All nested columns must have
#> the same number of elements.





