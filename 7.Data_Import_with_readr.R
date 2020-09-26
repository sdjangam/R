#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)

heights <- read_csv("data/heights.csv")

read_csv("a,b,c
1,2,3
4,5,6")

read_csv("The first line of metadata
The second line of metadata
x,y,z
1,2,3", skip = 2)

read_csv("# A comment I want to skip
x,y,z
1,2,3", comment = "#")

read_csv("1,2,3\n4,5,6", col_names = FALSE)

read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

read_csv("a,b,c\n1,2,.", na = ".")

#Parsing a Vector
str(parse_logical(c("TRUE", "FALSE", "NA")))
#> logi [1:3] TRUE FALSE NA
str(parse_integer(c("1", "2", "3")))
#> int [1:3] 1 2 3
str(parse_date(c("2010-01-01", "1979-10-14")))
#> Date[1:2], format: "2010-01-01" "1979-10-14"

parse_integer(c("1", "231", ".", "456"), na = ".")
#> [1] 1 231 NA 456

x <- parse_integer(c("123", "345", "abc", "123.45"))
#> Warning: 2 parsing failures.
#> row col expected actual
#> 3 -- an integer abc
#> 4 -- no trailing characters .45

x
#> [1] 123 345 NA NA
#> attr(,"problems")
#> # A tibble: 2 × 4
#> row col expected actual
#> <int> <int> <chr> <chr>
#> 1 3 NA an integer abc
#> 2 4 NA no trailing characters .45

problems(x)
#> # A tibble: 2 × 4
#> row col expected actual
#> <int> <int> <chr> <chr>
#> 1 3 NA an integer abc
#> 2 4 NA no trailing characters .45

#Numbers

parse_double("1.23")
#> [1] 1.23
parse_double("1,23", locale = locale(decimal_mark = ","))
#> [1] 1.23

parse_number("$100")
#> [1] 100
parse_number("20%")
#> [1] 20
parse_number("It cost $123.45")
#> [1] 123

# Used in America
parse_number("$123,456,789")
#> [1] 1.23e+08
# Used in many parts of Europe
parse_number(
"123.456.789",
locale = locale(grouping_mark = ".")
)
#> [1] 1.23e+08
# Used in Switzerland
parse_number(
"123'456'789",
locale = locale(grouping_mark = "'")
)
#> [1] 1.23e+08

#Strings

charToRaw("Hadley")
#> [1] 48 61 64 6c 65 79

x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

parse_character(x1, locale = locale(encoding = "Latin1"))
#> [1] "El Niño was particularly bad this year"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
#> [1] "こんにちは"

guess_encoding(charToRaw(x1))
#> encoding confidence
#> 1 ISO-8859-1 0.46
#> 2 ISO-8859-9 0.23
guess_encoding(charToRaw(x2))
#> encoding confidence
#> 1 KOI8-R 0.42

#Factors
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
#> Warning: 1 parsing failure.
#> row col expected actual
#> 3 -- value in level set bananana
#> [1] apple banana <NA>
#> attr(,"problems")
#> # A tibble: 1 × 4
#> row col expected actual
#> <int> <int> <chr> <chr>
#> 1 3 NA value in level set bananana
#> Levels: apple banana

#Dates, Date-Times, and Times

parse_datetime("2010-10-01T2010")
#> [1] "2010-10-01 20:10:00 UTC"
# If time is omitted, it will be set to midnight
parse_datetime("20101010")
#> [1] "2010-10-10 UTC"

parse_date("2010-10-01")
#> [1] "2010-10-01"

library(hms)
parse_time("01:10 am")
#> 01:10:00
parse_time("20:10:01")
#> 20:10:01

parse_date("01/02/15", "%m/%d/%y")
#> [1] "2015-01-02"
parse_date("01/02/15", "%d/%m/%y")
#> [1] "2015-02-01"
parse_date("01/02/15", "%y/%m/%d")
#> [1] "2001-02-15"

parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
#> [1] "2015-01-01"



#Parsing a File


guess_parser("2010-10-01")
#> [1] "date"
guess_parser("15:01")
#> [1] "time"
guess_parser(c("TRUE", "FALSE"))
#> [1] "logical"
guess_parser(c("1", "5", "9"))
#> [1] "integer"
guess_parser(c("12,352,561"))
#> [1] "number"
str(parse_guess("2010-10-10"))
#> Date[1:1], format: "2010-10-10"

#Problems
challenge <- read_csv(readr_example("challenge.csv"))
#> Parsed with column specification:
#> cols(
#> x = col_integer(),
#> y = col_character()
#> )
#> Warning: 1000 parsing failures.
#> row col expected actual
#> 1001 x no trailing characters .23837975086644292
#> 1002 x no trailing characters .41167997173033655
#> 1003 x no trailing characters .7460716762579978
#> 1004 x no trailing characters .723450553836301
#> 1005 x no trailing characters .614524137461558
#> .... ... ...................... ..................
#> See problems(...) for more details.

problems(challenge)
#> # A tibble: 1,000 × 4
#> row col expected actual
#> <int> <chr> <chr> <chr>
#> 1 1001 x no trailing characters .23837975086644292
#> 2 1002 x no trailing characters .41167997173033655
#> 3 1003 x no trailing characters .7460716762579978
#> 4 1004 x no trailing characters .723450553836301
#> 5 1005 x no trailing characters .614524137461558
#> 6 1006 x no trailing characters .473980569280684
#> # ... with 994 more rows

challenge <- read_csv(
readr_example("challenge.csv"),
col_types = cols(
x = col_integer(),
y = col_character()
)
)

challenge <- read_csv(
readr_example("challenge.csv"),
col_types = cols(
x = col_double(),
y = col_character()
)
)

tail(challenge)
#> # A tibble: 6 × 2
#> x y
#> <dbl> <chr>
#> 1 0.805 2019-11-21
#> 2 0.164 2018-03-29
#> 3 0.472 2014-08-04
#> 4 0.718 2015-08-16
#> 5 0.270 2020-02-04
#> 6 0.608 2019-01-06

challenge <- read_csv(
readr_example("challenge.csv"),
col_types = cols(
x = col_double(),
y = col_date()
)
)
tail(challenge)
#> # A tibble: 6 × 2
#> x y
#> <dbl> <date>
#> 1 0.805 2019-11-21
#> 2 0.164 2018-03-29
#> 3 0.472 2014-08-04
#> 4 0.718 2015-08-16
#> 5 0.270 2020-02-04
#> 6 0.608 2019-01-06

#Other Strategies

challenge2 <- read_csv(
readr_example("challenge.csv"),
guess_max = 1001
)
#> Parsed with column specification:
#> cols(
#> x = col_double(),
#> y = col_date(format = "")
#> )
challenge2
#> # A tibble: 2,000 × 2
#> x y
#> <dbl> <date>
#> 1 404 <NA>
#> 2 4172 <NA>
#> 3 3004 <NA>
#> 4 787 <NA>
#> 5 37 <NA>
#> 6 2332 <NA>
#> # ... with 1,994 more rows

challenge2 <- read_csv(readr_example("challenge.csv"),
col_types = cols(.default = col_character())
)

df <- tribble(
~x, ~y,
"1", "1.21",
"2", "2.32",
"3", "4.56"
)
df
#> # A tibble: 3 × 2
#> x y
#> <chr> <chr>
#> 1 1 1.21
#> 2 2 2.32
#> 3 3 4.56

# Note the column types
type_convert(df)
#> Parsed with column specification:
#> cols(
#> x = col_integer(),
#> y = col_double()
#> )
#> # A tibble: 3 × 2
#> x y
#> <int> <dbl>
#> 1 1 1.21
#> 2 2 2.32
#> 3 3 4.56

#Writing to a File

write_csv(challenge, "challenge.csv")

challenge
#> # A tibble: 2,000 × 2
#> x y
#> <dbl> <date>
#> 1 404 <NA>
#> 2 4172 <NA>
#> 3 3004 <NA>
#> 4 787 <NA>
#> 5 37 <NA>
#> 6 2332 <NA>
#> # ... with 1,994 more rows
write_csv(challenge, "challenge-2.csv")
read_csv("challenge-2.csv")
#> Parsed with column specification:
#> cols(
#> x = col_double(),
#> y = col_character()
#> )
#> # A tibble: 2,000 × 2
#> x y
#> <dbl> <chr>
#> 1 404 <NA>
#> 2 4172 <NA>
#> 3 3004 <NA>
#> 4 787 <NA>
#> 5 37 <NA>
#> 6 2332 <NA>
#> # ... with 1,994 more rows

write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")
#> # A tibble: 2,000 × 2
#> x y
#> <dbl> <date>
#> 1 404 <NA>
#> 2 4172 <NA>
#> 3 3004 <NA>
#> 4 787 <NA>
#> 5 37 <NA>
#> 6 2332 <NA>
#> # ... with 1,994 more rows

library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
#> # A tibble: 2,000 x 2
#> x y
#> <dbl> <date>
#> 1 404 <NA>
#> 2 4172 <NA>
#> 3 3004 <NA>
#> 4 787 <NA>
#> 5 37 <NA>
#> 6 2332 <NA>
#> # ... with 1,994 more rows

