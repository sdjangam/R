#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)

#Creating Tibbles

as_tibble(iris)

tibble(
x = 1:5,
y = 1,
z = x ^ 2 + y
)

tb <- tibble(
`:)` = "smile",
` ` = "space",
`2000` = "number"
)
tb

tribble(
~x, ~y, ~z,
#--|--|----
"a", 2, 3.6,
"b", 1, 8.5
)

#Tibbles Versus data.frame
#printing
tibble(
a = lubridate::now() + runif(1e3) * 86400,
b = lubridate::today() + runif(1e3) * 30,
c = 1:1e3,
d = runif(1e3),
e = sample(letters, 1e3, replace = TRUE)
)

nycflights13::flights %>%
print(n = 10, width = Inf)

nycflights13::flights %>%
View()

#subsetting
df <- tibble(
x = runif(5),
y = rnorm(5)
)

# Extract by name
df$x
df[["x"]]
# Extract by position
df[[1]]

#with pipes
df %>% .$x
df %>% .[["x"]]

#Interacting with Older Code
class(as.data.frame(tb))

