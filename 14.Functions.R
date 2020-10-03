#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

#When Should You Write a Function?


df <- tibble::tibble(
a = rnorm(10),
b = rnorm(10),
c = rnorm(10),
d = rnorm(10)
)
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
(max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
(max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) /
(max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) /
(max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))


(df$a - min(df$a, na.rm = TRUE)) /
(max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))

x <- df$a
(x - min(x, na.rm = TRUE)) /
(max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
#> [1] 0.289 0.751 0.000 0.678 0.853 1.000 0.172 0.611 0.612
#> [10] 0.601

rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])
#> [1] 0.289 0.751 0.000 0.678 0.853 1.000 0.172 0.611 0.612
#> [10] 0.601

rescale01 <- function(x) {
rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])
}
rescale01(c(0, 5, 10))
#> [1] 0.0 0.5 1.0

rescale01(c(-10, 0, 10))
#> [1] 0.0 0.5 1.0
rescale01(c(1, 2, 3, NA, 5))
#> [1] 0.00 0.25 0.50 NA 1.00

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)

x <- c(1:10, Inf)
rescale01(x)
#> [1] 0 0 0 0 0 0 0 0 0 0 NaN

rescale01 <- function(x) {
rng <- range(x, na.rm = TRUE, finite = TRUE)
(x - rng[1]) / (rng[2] - rng[1])
}
rescale01(x)
#> [1] 0.000 0.111 0.222 0.333 0.444 0.556 0.667 0.778 0.889
#> [10] 1.000 Inf

#Functions Are for Humans and Computers
# Too short
f()
# Not a verb, or descriptive
my_awesome_function()
# Long, but clear
impute_missing()
collapse_years()


# Good
input_select()
input_checkbox()
input_text()

# Not so good
select_input()
checkbox_input()
text_input()

# Don't do this!
T <- FALSE
c <- 10
mean <- function(x) sum(x)

#Conditional Execution

if (condition) {
# code executed when condition is TRUE
} else {
# code executed when condition is FALSE
}

if (condition) {
# code executed when condition is TRUE
} else {
# code executed when condition is FALSE
}
} else {
!is.na(nms) & nms != ""
}
}


#Conditions

if (c(TRUE, FALSE)) {}
#> Warning in if (c(TRUE, FALSE)) {:
#> the condition has length > 1 and only the
#> first element will be used
#> NULL
if (NA) {}
#> Error in if (NA) {: missing value where TRUE/FALSE needed

identical(0L, 0)
#> [1] FALSE

x <- sqrt(2) ^ 2
x
#> [1] 2
x == 2
#> [1] FALSE
x - 2
#> [1] 4.44e-16


#Multiple Conditions

if (this) {
# do that
} else if (that) {
# do something else
} else {
#
}

#> function(x, y, op) {
#> switch(op,
#> plus = x + y,
#> minus = x - y,
#> times = x * y,
#> divide = x / y,
#> stop("Unknown op!")
#> )
#> }

#Code Style

# Good
if (y < 0 && debug) {
message("Y is negative")
}
if (y == 0) {
log(x)
} else {
y ^ x
}
# Bad
if (y < 0 && debug)
message("Y is negative")
if (y == 0) {
log(x)
}
else {
y ^ x
}

y <- 10
x <- if (y < 20) "Too low" else "Too high"

if (y < 20) {
x <- "Too low"
} else {
x <- "Too high"
}

#Function Arguments

# Compute confidence interval around
# mean using normal approximation
mean_ci <- function(x, conf = 0.95) {
se <- sd(x) / sqrt(length(x))
alpha <- 1 - conf
mean(x) + se * qnorm(c(alpha / 2, 1 - alpha / 2))
}
x <- runif(100)
mean_ci(x)
#> [1] 0.498 0.610
mean_ci(x, conf = 0.99)
#> [1] 0.480 0.628

# Good
mean(1:10, na.rm = TRUE)
# Bad
mean(x = 1:10, , FALSE)
mean(, TRUE, x = c(1:10, NA))

# Good
average <- mean(feet / 12 + inches, na.rm = TRUE)
# Bad
average<-mean(feet/12+inches,na.rm=TRUE)

#Checking Values

wt_mean <- function(x, w) {
sum(x * w) / sum(x)
}
wt_var <- function(x, w) {
mu <- wt_mean(x, w)
sum(w * (x - mu) ^ 2) / sum(w)
}
wt_sd <- function(x, w) {
sqrt(wt_var(x, w))
}

wt_mean(1:6, 1:3)
#> [1] 2.19

wt_mean <- function(x, w) {
if (length(x) != length(w)) {
stop("`x` and `w` must be the same length", call. = FALSE)
}
sum(w * x) / sum(x)
}

wt_mean <- function(x, w, na.rm = FALSE) {
if (!is.logical(na.rm)) {
stop("`na.rm` must be logical")
}
if (length(na.rm) != 1) {
stop("`na.rm` must be length 1")
}
if (length(x) != length(w)) {
stop("`x` and `w` must be the same length", call. = FALSE)
}
if (na.rm) {
miss <- is.na(x) | is.na(w)
x <- x[!miss]
w <- w[!miss]
}
sum(w * x) / sum(x)
}

wt_mean <- function(x, w, na.rm = FALSE) {
stopifnot(is.logical(na.rm), length(na.rm) == 1)
stopifnot(length(x) == length(w))
if (na.rm) {
miss <- is.na(x) | is.na(w)
x <- x[!miss]
w <- w[!miss]
}
sum(w * x) / sum(x)
}
wt_mean(1:6, 6:1, na.rm = "foo")
#> Error: is.logical(na.rm) is not TRUE


#Dot-Dot-Dot (…)

sum(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#> [1] 55
stringr::str_c("a", "b", "c", "d", "e", "f")
#> [1] "abcdef"

commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])
#> [1] "a, b, c, d, e, f, g, h, i, j"
rule <- function(..., pad = "-") {
title <- paste0(...)
width <- getOption("width") - nchar(title) - 5
cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")
#> Important output ----------------------------------------

x <- c(1, 2)
sum(x, na.mr = TRUE)
#> [1] 4

#Return Values
#Explicit Return Statements

complicated_function <- function(x, y, z) {
if (length(x) == 0 || length(y) == 0) {
return(0)
}
# Complicated code here
}

f <- function() {
if (x) {
# Do
# something
# that
# takes
# many
# lines
# to
# express
} else {
# return something short
}
}

f <- function() {
if (!x) {
return(something_short)
}
# Do
# something
# that
# takes
# many
# lines
# to
# express
}


#Writing Pipeable Functions

show_missings <- function(df) {
n <- sum(is.na(df))
cat("Missing values: ", n, "\n", sep = "")
invisible(df)
}

show_missings(mtcars)
#> Missing values: 0

x <- show_missings(mtcars)
#> Missing values: 0
class(x)
#> [1] "data.frame"
dim(x)
#> [1] 32 11

mtcars %>%
show_missings() %>%
mutate(mpg = ifelse(mpg < 20, NA, mpg)) %>%
show_missings()
#> Missing values: 0
#> Missing values: 18

#Environment

f <- function(x) {
x + y
}

y <- 100
f(10)
#> [1] 110

y <- 1000
f(10)
#> [1] 1010


`+` <- function(x, y) {
if (runif(1) < 0.1) {
sum(x, y)
} else {
sum(x, y) * 1.1
}
}
table(replicate(1000, 1 + 2))
#>
#> 3 3.3
#> 100 900
rm(`+`)

