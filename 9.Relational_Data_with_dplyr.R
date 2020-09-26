#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)
library(nycflights13)


#nycflights13
airlines
#> # A tibble: 16 × 2
#> carrier name
#> <chr> <chr>
#> 1 9E Endeavor Air Inc.
#> 2 AA American Airlines Inc.
#> 3 AS Alaska Airlines Inc.
#> 4 B6 JetBlue Airways
#> 5 DL Delta Air Lines Inc.
#> 6 EV ExpressJet Airlines Inc.
#> # ... with 10 more rows

airports
#> # A tibble: 1,396 × 7
#> faa name lat lon
#> <chr> <chr> <dbl> <dbl>
#> 1 04G Lansdowne Airport 41.1 -80.6
#> 2 06A Moton Field Municipal Airport 32.5 -85.7
#> 3 06C Schaumburg Regional 42.0 -88.1
#> 4 06N Randall Airport 41.4 -74.4
#> 5 09J Jekyll Island Airport 31.1 -81.4
#> 6 0A9 Elizabethton Municipal Airport 36.4 -82.2
#> # ... with 1,390 more rows, and 3 more variables:
#> # alt <int>, tz <dbl>, dst <chr>

planes
#> # A tibble: 3,322 × 9
#> tailnum year type
#> <chr> <int> <chr>
#> 1 N10156 2004 Fixed wing multi engine
#> 2 N102UW 1998 Fixed wing multi engine
#> 3 N103US 1999 Fixed wing multi engine
#> 4 N104UW 1999 Fixed wing multi engine
#> 5 N10575 2002 Fixed wing multi engine
#> 6 N105UW 1999 Fixed wing multi engine
#> # ... with 3,316 more rows, and 6 more variables:
#> # manufacturer <chr>, model <chr>, engines <int>,
#> # seats <int>, speed <int>, engine <chr>

weather
#> # A tibble: 26,130 × 15
#> origin year month day hour temp dewp humid
#> <chr> <dbl> <dbl> <int> <int> <dbl> <dbl> <dbl>
#> 1 EWR 2013 1 1 0 37.0 21.9 54.0
#> 2 EWR 2013 1 1 1 37.0 21.9 54.0
#> 3 EWR 2013 1 1 2 37.9 21.9 52.1
#> 4 EWR 2013 1 1 3 37.9 23.0 54.5
#> 5 EWR 2013 1 1 4 37.9 24.1 57.0
#> 6 EWR 2013 1 1 6 39.0 26.1 59.4
#> # ... with 2.612e+04 more rows, and 7 more variables:
#> # wind_dir <dbl>, wind_speed <dbl>, wind_gust <dbl>,
#> # precip <dbl>, pressure <dbl>, visib <dbl>,
#> # time_hour <dttm>

#Keys
planes %>%
count(tailnum) %>%
filter(n > 1)
#> # A tibble: 0 × 2
#> # ... with 2 variables: tailnum <chr>, n <int>

weather %>%
count(year, month, day, hour, origin) %>%
filter(n > 1)
#> Source: local data frame [0 x 6]
#> Groups: year, month, day, hour [0]
#>
#> # ... with 6 variables: year <dbl>, month <dbl>, day <int>,
#> # hour <int>, origin <chr>, n <int>

flights %>%
count(year, month, day, flight) %>%
filter(n > 1)
#> Source: local data frame [29,768 x 5]
#> Groups: year, month, day [365]
#>
#> year month day flight n
#> <int> <int> <int> <int> <int>
#> 1 2013 1 1 1 2
#> 2 2013 1 1 3 2
#> 3 2013 1 1 4 2
#> 4 2013 1 1 11 3
#> 5 2013 1 1 15 2
#> 6 2013 1 1 21 2
#> # ... with 2.976e+04 more rows
flights %>%
count(year, month, day, tailnum) %>%
filter(n > 1)
#> Source: local data frame [64,928 x 5]
#> Groups: year, month, day [365]
#>
#> year month day tailnum n
#> <int> <int> <int> <chr> <int>
#> 1 2013 1 1 N0EGMQ 2
#> 2 2013 1 1 N11189 2
#> 3 2013 1 1 N11536 2
#> 4 2013 1 1 N11544 3
#> 5 2013 1 1 N11551 2
#> 6 2013 1 1 N12540 2
#> # ... with 6.492e+04 more rows

#Mutating Joins

flights2 <- flights %>%
select(year:day, hour, origin, dest, tailnum, carrier)
flights2
#> # A tibble: 336,776 × 8
#> year month day hour origin dest tailnum carrier
#> <int> <int> <int> <dbl> <chr> <chr> <chr> <chr>
#> 1 2013 1 1 5 EWR IAH N14228 UA
#> 2 2013 1 1 5 LGA IAH N24211 UA
#> 3 2013 1 1 5 JFK MIA N619AA AA
#> 4 2013 1 1 5 JFK BQN N804JB B6
#> 5 2013 1 1 6 LGA ATL N668DN DL
#> 6 2013 1 1 5 EWR ORD N39463 UA
#> # ... with 3.368e+05 more rows

flights2 %>%
select(-origin, -dest) %>%
left_join(airlines, by = "carrier")
#> # A tibble: 336,776 × 7
#> year month day hour tailnum carrier
#> <int> <int> <int> <dbl> <chr> <chr>
#> 1 2013 1 1 5 N14228 UA
#> 2 2013 1 1 5 N24211 UA
#> 3 2013 1 1 5 N619AA AA
#> 4 2013 1 1 5 N804JB B6
#> 5 2013 1 1 6 N668DN DL
#> 6 2013 1 1 5 N39463 UA
#> # ... with 3.368e+05 more rows, and 1 more variable:
#> # name <chr>

flights2 %>%
select(-origin, -dest) %>%
mutate(name = airlines$name[match(carrier, airlines$carrier)])
#> # A tibble: 336,776 × 7
#> year month day hour tailnum carrier
#> <int> <int> <int> <dbl> <chr> <chr>
#> 1 2013 1 1 5 N14228 UA
#> 2 2013 1 1 5 N24211 UA
#> 3 2013 1 1 5 N619AA AA
#> 4 2013 1 1 5 N804JB B6
#> 5 2013 1 1 6 N668DN DL
#> 6 2013 1 1 5 N39463 UA
#> # ... with 3.368e+05 more rows, and 1 more variable:
#> # name <chr>

#Understanding Joins
x <- tribble(
~key, ~val_x,
1, "x1",
2, "x2",
3, "x3"
)

y <- tribble(
~key, ~val_y,
1, "y1",
2, "y2",
4, "y3"
)

#Inner Join
x %>%
inner_join(y, by = "key")
#> # A tibble: 2 × 3
#> key val_x val_y
#> <dbl> <chr> <chr>
#> 1 1 x1 y1
#> 2 2 x2 y2

#Outer Joins

#Duplicate Keys
x <- tribble(
~key, ~val_x,
1, "x1",
2, "x2",
2, "x3",
1, "x4"
)
y <- tribble(
~key, ~val_y,
1, "y1",
2, "y2"
)
left_join(x, y, by = "key")
#> # A tibble: 4 × 3
#> key val_x val_y
#> <dbl> <chr> <chr>
#> 1 1 x1 y1
#> 2 2 x2 y2
#> 3 2 x3 y2
#> 4 1 x4 y1

x <- tribble(
~key, ~val_x,
1, "x1",
2, "x2",
2, "x3",
3, "x4"
)
y <- tribble(
~key, ~val_y,
1, "y1",
2, "y2",
2, "y3",
3, "y4"
)
left_join(x, y, by = "key")
#> # A tibble: 6 × 3
#> key val_x val_y
#> <dbl> <chr> <chr>
#> 1 1 x1 y1
#> 2 2 x2 y2
#> 3 2 x2 y3
#> 4 2 x3 y2
#> 5 2 x3 y3
#> 6 3 x4 y4

#Defining the Key Columns

flights2 %>%
left_join(weather)
#> Joining, by = c("year", "month", "day", "hour",
#> "origin")
#> # A tibble: 336,776 × 18
#> year month day hour origin dest tailnum
#> <dbl> <dbl> <int> <dbl> <chr> <chr> <chr>
#> 1 2013 1 1 5 EWR IAH N14228
#> 2 2013 1 1 5 LGA IAH N24211
#> 3 2013 1 1 5 JFK MIA N619AA
#> 4 2013 1 1 5 JFK BQN N804JB
#> 5 2013 1 1 6 LGA ATL N668DN
#> 6 2013 1 1 5 EWR ORD N39463
#> # ... with 3.368e+05 more rows, and 11 more variables:
#> # carrier <chr>, temp <dbl>, dewp <dbl>,
#> # humid <dbl>, wind_dir <dbl>, wind_speed <dbl>,
#> # wind_gust <dbl>, precip <dbl>, pressure <dbl>,
#> # visib <dbl>, time_hour <dttm>

flights2 %>%
left_join(planes, by = "tailnum")
#> # A tibble: 336,776 × 16
#> year.x month day hour origin dest tailnum
#> <int> <int> <int> <dbl> <chr> <chr> <chr>
#> 1 2013 1 1 5 EWR IAH N14228
#> 2 2013 1 1 5 LGA IAH N24211
#> 3 2013 1 1 5 JFK MIA N619AA
#> 4 2013 1 1 5 JFK BQN N804JB
#> 5 2013 1 1 6 LGA ATL N668DN
#> 6 2013 1 1 5 EWR ORD N39463
#> # ... with 3.368e+05 more rows, and 9 more variables:
#> # carrier <chr>, year.y <int>, type <chr>,
#> # manufacturer <chr>, model <chr>, engines <int>,
#> # seats <int>, speed <int>, engine <chr>

flights2 %>%
left_join(airports, c("dest" = "faa"))
#> # A tibble: 336,776 × 14
#> year month day hour origin dest tailnum
#> <int> <int> <int> <dbl> <chr> <chr> <chr>
#> 1 2013 1 1 5 EWR IAH N14228
#> 2 2013 1 1 5 LGA IAH N24211
#> 3 2013 1 1 5 JFK MIA N619AA
#> 4 2013 1 1 5 JFK BQN N804JB
#> 5 2013 1 1 6 LGA ATL N668DN
#> 6 2013 1 1 5 EWR ORD N39463
#> # ... with 3.368e+05 more rows, and 7 more variables:
#> # carrier <chr>, name <chr>, lat <dbl>, lon <dbl>,
#> # alt <int>, tz <dbl>, dst <chr>

flights2 %>%
left_join(airports, c("origin" = "faa"))
#> # A tibble: 336,776 × 14
#> year month day hour origin dest tailnum
#> <int> <int> <int> <dbl> <chr> <chr> <chr>
#> 1 2013 1 1 5 EWR IAH N14228
#> 2 2013 1 1 5 LGA IAH N24211
#> 3 2013 1 1 5 JFK MIA N619AA
#> 4 2013 1 1 5 JFK BQN N804JB
#> 5 2013 1 1 6 LGA ATL N668DN
#> 6 2013 1 1 5 EWR ORD N39463
#> # ... with 3.368e+05 more rows, and 7 more variables:
#> # carrier <chr>, name <chr>, lat <dbl>, lon <dbl>,
#> # alt <int>, tz <dbl>, dst <chr>

#Filtering Joins

top_dest <- flights %>%
count(dest, sort = TRUE) %>%
head(10)
top_dest
#> # A tibble: 10 × 2
#> dest n
#> <chr> <int>
#> 1 ORD 17283
#> 2 ATL 17215
#> 3 LAX 16174
#> 4 BOS 15508
#> 5 MCO 14082
#> 6 CLT 14064
#> # ... with 4 more rows

flights %>%
filter(dest %in% top_dest$dest)
#> # A tibble: 141,145 × 19
#> year month day dep_time sched_dep_time dep_delay
#> <int> <int> <int> <int> <int> <dbl>
#> 1 2013 1 1 542 540 2
#> 2 2013 1 1 554 600 -6
#> 3 2013 1 1 554 558 -4
#> 4 2013 1 1 555 600 -5
#> 5 2013 1 1 557 600 -3
#> 6 2013 1 1 558 600 -2
#> # ... with 1.411e+05 more rows, and 12 more variables:
#> # arr_time <int>, sched_arr_time <int>, arr_delay <dbl>,
#> # carrier <chr>, flight <int>, tailnum <chr>, origin <chr>,
#> # dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> # minute <dbl>, time_hour <dttm>

flights %>%
semi_join(top_dest)
#> Joining, by = "dest"
#> # A tibble: 141,145 × 19
#> year month day dep_time sched_dep_time dep_delay
#> <int> <int> <int> <int> <int> <dbl>
#> 1 2013 1 1 554 558 -4
#> 2 2013 1 1 558 600 -2
#> 3 2013 1 1 608 600 8
#> 4 2013 1 1 629 630 -1
#> 5 2013 1 1 656 700 -4
#> 6 2013 1 1 709 700 9
#> # ... with 1.411e+05 more rows, and 13 more variables:
#> # arr_time <int>, sched_arr_time <int>, arr_delay <dbl>,
#> # carrier <chr>, flight <int>, tailnum <chr>, origin <chr>,
#> # dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
#> # minute <dbl>, time_hour <dttm>

flights %>%
anti_join(planes, by = "tailnum") %>%
count(tailnum, sort = TRUE)
#> # A tibble: 722 × 2
#> tailnum n
#> <chr> <int>
#> 1 <NA> 2512
#> 2 N725MQ 575
#> 3 N722MQ 513
#> 4 N723MQ 507
#> 5 N713MQ 483
#> 6 N735MQ 396
#> # ... with 716 more rows

#Join Problems

airports %>% count(alt, lon) %>% filter(n > 1)
#> Source: local data frame [0 x 3]
#> Groups: alt [0]
#>
#> # ... with 3 variables: alt <int>, lon <dbl>, n <int>

#Set Operations

df1 <- tribble(
~x, ~y,
1, 1,
2, 1
)
df2 <- tribble(
~x, ~y,
1, 1,
1, 2
)

intersect(df1, df2)
#> # A tibble: 1 × 2
#> x y
#> <dbl> <dbl>
#> 1 1 1
# Note that we get 3 rows, not 4
union(df1, df2)
#> # A tibble: 3 × 2
#> x y
#> <dbl> <dbl>
#> 1 1 2
#> 2 2 1
#> 3 1 1
setdiff(df1, df2)
#> # A tibble: 1 × 2
#> x y
#> <dbl> <dbl>
#> 1 2 1
setdiff(df2, df1)
#> # A tibble: 1 × 2
#> x y
#> <dbl> <dbl>
#> 1 1 2

