#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(magrittr)

foo_foo <- little_bunny()

#Intermediate Steps
foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)

diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>%
dplyr::mutate(price_per_carat = price / carat)
pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 3.89 MB

diamonds$carat[1] <- NA
pryr::object_size(diamonds)
#> 3.46 MB
pryr::object_size(diamonds2)
#> 3.89 MB
pryr::object_size(diamonds, diamonds2)
#> 4.32 MB

#Overwrite the Original

foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

bop(
scoop(
hop(foo_foo, through = forest),
up = field_mice
),
on = head
)

#Use the Pipe

foo_foo %>%
hop(through = forest) %>%
scoop(up = field_mouse) %>%
bop(on = head)

my_pipe <- function(.) {
. <- hop(., through = forest)
. <- scoop(., up = field_mice)
bop(., on = head)
}
my_pipe(foo_foo)

assign("x", 10)
x
#> [1] 10
"x" %>% assign(100)
x
#> [1] 10

env <- environment()
"x" %>% assign(100, envir = env)
x
#> [1] 100

tryCatch(stop("!"), error = function(e) "An error")
#> [1] "An error"
stop("!") %>%
tryCatch(error = function(e) "An error")
#> Error in eval(expr, envir, enclos): !

#Other Tools from magrittr

rnorm(100) %>%
matrix(ncol = 2) %>%
plot() %>%
str()
#> NULL

rnorm(100) %>%
matrix(ncol = 2) %T>%
plot() %>%
str()
#> num [1:50, 1:2] -0.387 -0.785 -1.057 -0.796 -1.756 ...

mtcars %$%
cor(disp, mpg)
#> [1] -0.848

mtcars <- mtcars %>%
transform(cyl = cyl * 2)

mtcars %<>% transform(cyl = cyl * 2)

