#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

#R works like a calculator
1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

#Assignment in R
x <- 3 * 4
x

this_is_a_really_long_name <- 2.5
r_rocks <- 2 ^ 3
r_rock
R_rocks

#Calling functions
seq(1, 10)

x <- "hello 

world"
x

y <- seq(1, 10, length.out = 5)
y

(y <- seq(1, 10, length.out = 5))


#Projects

library(tidyverse)
ggplot(diamonds, aes(carat, price)) +
geom_hex()
ggsave("diamonds.pdf")
write_csv(diamonds, "diamonds.csv")