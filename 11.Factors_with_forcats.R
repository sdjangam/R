#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)
library(forcats)

#Creating Factors
x1 <- c("Dec", "Apr", "Jan", "Mar")

x2 <- c("Dec", "Apr", "Jam", "Mar")

sort(x1)
#> [1] "Apr" "Dec" "Jan" "Mar"

month_levels <- c(
"Jan", "Feb", "Mar", "Apr", "May", "Jun",
"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

y1 <- factor(x1, levels = month_levels)
y1
#> [1] Dec Apr Jan Mar
#> Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
sort(y1)
#> [1] Jan Mar Apr Dec
#> Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

y2 <- factor(x2, levels = month_levels)
y2
#> [1] Dec Apr <NA> Mar
#> Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

y2 <- parse_factor(x2, levels = month_levels)
#> Warning: 1 parsing failure.
#> row col expected actual
#> 3 -- value in level set Jam

factor(x1)
#> [1] Dec Apr Jan Mar
#> Levels: Apr Dec Jan Mar

f1 <- factor(x1, levels = unique(x1))
f1
#> [1] Dec Apr Jan Mar
#> Levels: Dec Apr Jan Mar
f2 <- x1 %>% factor() %>% fct_inorder()
f2
#> [1] Dec Apr Jan Mar
#> Levels: Dec Apr Jan Mar

#levels(f2)
#> [1] "Dec" "Apr" "Jan" "Mar"


#General Social Survey
gss_cat
#> # A tibble: 21,483 × 9
#> year marital age race rincome
#> <int> <fctr> <int> <fctr> <fctr>
#> 1 2000 Never married 26 White $8000 to 9999
#> 2 2000 Divorced 48 White $8000 to 9999
#> 3 2000 Widowed 67 White Not applicable
#> 4 2000 Never married 39 White Not applicable
#> 5 2000 Divorced 25 White Not applicable
#> 6 2000 Married 25 White $20000 - 24999
#> # ... with 2.148e+04 more rows, and 4 more variables:
#> # partyid <fctr>, relig <fctr>, denom <fctr>, tvhours <int>

gss_cat %>%
count(race)
#> # A tibble: 3 × 2
#> race n
#> <fctr> <int>
#> 1 Other 1959
#> 2 Black 3129
#> 3 White 16395

ggplot(gss_cat, aes(race)) +
geom_bar()

ggplot(gss_cat, aes(race)) +
geom_bar() +
scale_x_discrete(drop = FALSE)

#Modifying Factor Order

relig <- gss_cat %>%
group_by(relig) %>%
summarize(
age = mean(age, na.rm = TRUE),
tvhours = mean(tvhours, na.rm = TRUE),
n = n()
)
ggplot(relig, aes(tvhours, relig)) + geom_point()

ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) +
geom_point()

relig %>%
mutate(relig = fct_reorder(relig, tvhours)) %>%
ggplot(aes(tvhours, relig)) +
geom_point()

rincome <- gss_cat %>%
group_by(rincome) %>%
summarize(
age = mean(age, na.rm = TRUE),
tvhours = mean(tvhours, na.rm = TRUE),
n = n()
)
ggplot(
rincome,
aes(age, fct_reorder(rincome, age))
) + geom_point()

ggplot(
rincome,
aes(age, fct_relevel(rincome, "Not applicable"))
) +
geom_point()

by_age <- gss_cat %>%
filter(!is.na(age)) %>%
group_by(age, marital) %>%
count() %>%
mutate(prop = n / sum(n))
ggplot(by_age, aes(age, prop, color = marital)) +
geom_line(na.rm = TRUE)
ggplot(
by_age,
aes(age, prop, color = fct_reorder2(marital, age, prop))
) +
geom_line() +
labs(color = "marital")

gss_cat %>%
mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
ggplot(aes(marital)) +
geom_bar()

#Modifying Factor Levels

gss_cat %>% count(partyid)
#> # A tibble: 10 × 2
#> partyid n
#> <fctr> <int>
#> 1 No answer 154
#> 2 Don't know 1
#> 3 Other party 393
#> 4 Strong republican 2314
#> 5 Not str republican 3032
#> 6 Ind,near rep 1791
#> # ... with 4 more rows

gss_cat %>%
mutate(partyid = fct_recode(partyid,
"Republican, strong" = "Strong republican",
"Republican, weak" = "Not str republican",
"Independent, near rep" = "Ind,near rep",
"Independent, near dem" = "Ind,near dem",
"Democrat, weak" = "Not str democrat",
"Democrat, strong" = "Strong democrat"
)) %>%
count(partyid)
#> # A tibble: 10 × 2
#> partyid n
#> <fctr> <int>
#> 1 No answer 154
#> 2 Don't know 1
#> 3 Other party 393
#> 4 Republican, strong 2314
#> 5 Republican, weak 3032
#> 6 Independent, near rep 1791
#> # ... with 4 more rows

gss_cat %>%
mutate(partyid = fct_recode(partyid,
"Republican, strong" = "Strong republican",
"Republican, weak" = "Not str republican",
"Independent, near rep" = "Ind,near rep",
"Independent, near dem" = "Ind,near dem",
"Democrat, weak" = "Not str democrat",
"Democrat, strong" = "Strong democrat",
"Other" = "No answer",
"Other" = "Don't know",
"Other" = "Other party"
)) %>%
count(partyid)
#> # A tibble: 8 × 2
#> partyid n
#> <fctr> <int>
#> 1 Other 548
#> 2 Republican, strong 2314
#> 3 Republican, weak 3032
#> 4 Independent, near rep 1791
#> 5 Independent 4119
#> 6 Independent, near dem 2499
#> # ... with 2 more rows

gss_cat %>%
mutate(partyid = fct_collapse(partyid,
other = c("No answer", "Don't know", "Other party"),
rep = c("Strong republican", "Not str republican"),
ind = c("Ind,near rep", "Independent", "Ind,near dem"),
dem = c("Not str democrat", "Strong democrat")
)) %>%
count(partyid)
#> # A tibble: 4 × 2
#> partyid n
#> <fctr> <int>
#> 1 other 548
#> 2 rep 5346
#> 3 ind 8409
#> 4 dem 7180

gss_cat %>%
mutate(relig = fct_lump(relig)) %>%
count(relig)
#> # A tibble: 2 × 2
#> relig n
#> <fctr> <int>
#> 1 Protestant 10846
#> 2 Other 10637

gss_cat %>%
mutate(relig = fct_lump(relig, n = 10)) %>%
count(relig, sort = TRUE) %>%
print(n = Inf)
#> # A tibble: 10 × 2
#> relig n
#> <fctr> <int>
#> 1 Protestant 10846
#> 2 Catholic 5124
#> 3 None 3523
#> 4 Christian 689
#> 5 Other 458
#> 6 Jewish 388
#> 7 Buddhism 147
#> 8 Inter-nondenominational 109
#> 9 Moslem/islam 104
#> 10 Orthodox-christian 95


