#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")

library(tidyverse)
library(stringr)

string1 <- "This is a string"
string2 <- 'To put a "quote" inside a string, use single quotes'

double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"

x <- c("\"", "\\")
x
#> [1] "\"" "\\"
writeLines(x)
#> "
#> \


x <- "\u00b5"
x
#> [1] "μ"

c("one", "two", "three")
#> [1] "one" "two" "three"

#String Length

str_length(c("a", "R for data science", NA))
#> [1] 1 18 NA

#Combining Strings

str_c("x", "y")
#> [1] "xy"
str_c("x", "y", "z")
#> [1] "xyz"

str_c("x", "y", sep = ", ")
#> [1] "x, y"

x <- c("abc", NA)
str_c("|-", x, "-|")
#> [1] "|-abc-|" NA
str_c("|-", str_replace_na(x), "-|")
#> [1] "|-abc-|" "|-NA-|"

str_c("prefix-", c("a", "b", "c"), "-suffix")
#> [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"

name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE
str_c(
"Good ", time_of_day, " ", name,
if (birthday) " and HAPPY BIRTHDAY",
"."
)
#> [1] "Good morning Hadley."

str_c(c("x", "y", "z"), collapse = ", ")
#> [1] "x, y, z"

#Subsetting Strings

x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
#> [1] "App" "Ban" "Pea"
# negative numbers count backwards from end
str_sub(x, -3, -1)
#> [1] "ple" "ana" "ear"

str_sub("a", 1, 5)
#> [1] "a"

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
#> [1] "apple" "banana" "pear"

#Locales

# Turkish has two i's: with and without a dot, and it
# has a different rule for capitalizing them:
str_to_upper(c("i", "ı"))
#> [1] "I" "I"
str_to_upper(c("i", "ı"), locale = "tr")
#> [1] "İ" "I"

x <- c("apple", "eggplant", "banana")
str_sort(x, locale = "en") # English
#> [1] "apple" "banana" "eggplant"
str_sort(x, locale = "haw") # Hawaiian
#> [1] "apple" "eggplant" "banana"

#Matching Patterns with Regular Expressions

#Basic Matches
x <- c("apple", "banana", "pear")
str_view(x, "an")

str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."
# But the expression itself only contains one:
writeLines(dot)
#> \.
# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")

x <- "a\\b"
writeLines(x)
#> a\b
str_view(x, "\\\\")

#Anchors

x <- c("apple", "banana", "pear")
str_view(x, "^a")

str_view(x, "a$")

x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")

str_view(x, "^apple$")

#Character Classes and Alternatives

str_view(c("grey", "gray"), "gr(e|a)y")

#Repetition

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")

str_view(x, "CC+")

str_view(x, 'C[LX]+')

str_view(x, "C{2}")

str_view(x, "C{2,}")

str_view(x, "C{2,3}")

str_view(x, 'C{2,3}?')

str_view(x, 'C[LX]+?')

#Grouping and Backreferences

str_view(fruit, "(..)\\1", match = TRUE)

#Tools
#Detect Matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")
#> [1] TRUE FALSE TRUE

# How many common words start with t?
sum(str_detect(words, "^t"))
#> [1] 65
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))
#> [1] 0.277

# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
identical(no_vowels_1, no_vowels_2)
#> [1] TRUE

words[str_detect(words, "x$")]
#> [1] "box" "sex" "six" "tax"
str_subset(words, "x$")
#> [1] "box" "sex" "six" "tax"

df <- tibble(
word = words,
i = seq_along(word)
)
df %>%
filter(str_detect(words, "x$"))
#> # A tibble: 4 × 2
#> word i
#> <chr> <int>
#> 1 box 108
#> 2 sex 747
#> 3 six 772
#> 4 tax 841

x <- c("apple", "banana", "pear")
str_count(x, "a")
#> [1] 1 3 1
# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))
#> [1] 1.99

df %>%
mutate(
vowels = str_count(word, "[aeiou]"),
consonants = str_count(word, "[^aeiou]")
)
#> # A tibble: 980 × 4
#> word i vowels consonants
#> <chr> <int> <int> <int>
#> 1 a 1 1 0
#> 2 able 2 2 2
#> 3 about 3 3 2
#> 4 absolute 4 4 4
#> 5 accept 5 2 4
#> 6 account 6 3 4
#> # ... with 974 more rows

str_count("abababa", "aba")
#> [1] 2
str_view_all("abababa", "aba")

#Extract Matches

length(sentences)
#> [1] 720
head(sentences)
#> [1] "The birch canoe slid on the smooth planks."
#> [2] "Glue the sheet to the dark blue background."
#> [3] "It's easy to tell the depth of a well."
#> [4] "These days a chicken leg is a rare dish."
#> [5] "Rice is often served in round bowls."
#> [6] "The juice of lemons makes fine punch."

colors <- c(
"red", "orange", "yellow", "green", "blue", "purple"
)
color_match <- str_c(colors, collapse = "|")
color_match
#> [1] "red|orange|yellow|green|blue|purple"

has_color <- str_subset(sentences, color_match)
matches <- str_extract(has_color, color_match)
head(matches)
#> [1] "blue" "blue" "red" "red" "red" "blue"

more <- sentences[str_count(sentences, color_match) > 1]
str_view_all(more, color_match)


str_extract(more, color_match)
#> [1] "blue" "green" "orange"


str_extract_all(more, color_match)
#> [[1]]
#> [1] "blue" "red"
#>
#> [[2]]
#> [1] "green" "red"
#>
#> [[3]]
#> [1] "orange" "red"

str_extract_all(more, color_match, simplify = TRUE)
#> [,1] [,2]
#> [1,] "blue" "red"
#> [2,] "green" "red"
#> [3,] "orange" "red"
x <- c("a", "a b", "a b c")
str_extract_all(x, "[a-z]", simplify = TRUE)
#> [,1] [,2] [,3]
#> [1,] "a" "" ""
#> [2,] "a" "b" ""
#> [3,] "a" "b" "c"

#Grouped Matches

noun <- "(a|the) ([^ ]+)"
has_noun <- sentences %>%
str_subset(noun) %>%
head(10)
has_noun %>%
str_extract(noun)
#> [1] "the smooth" "the sheet" "the depth" "a chicken"
#> [5] "the parked" "the sun" "the huge" "the ball"
#> [9] "the woman" "a helps"

has_noun %>%
str_match(noun)
#> [,1] [,2] [,3]
#> [1,] "the smooth" "the" "smooth"
#> [2,] "the sheet" "the" "sheet"
#> [3,] "the depth" "the" "depth"
#> [4,] "a chicken" "a" "chicken"
#> [5,] "the parked" "the" "parked"
#> [6,] "the sun" "the" "sun"
#> [7,] "the huge" "the" "huge"
#> [8,] "the ball" "the" "ball"
#> [9,] "the woman" "the" "woman"
#> [10,] "a helps" "a" "helps"

tibble(sentence = sentences) %>%
tidyr::extract(
sentence, c("article", "noun"), "(a|the) ([^ ]+)",
remove = FALSE
)
#> # A tibble: 720 × 3
#> sentence article noun
#> * <chr> <chr> <chr>
#> 1 The birch canoe slid on the smooth planks. the smooth
#> 2 Glue the sheet to the dark blue background. the sheet
#> 3 It's easy to tell the depth of a well. the depth
#> 4 These days a chicken leg is a rare dish. a chicken
#> 5 Rice is often served in round bowls. <NA> <NA>
#> 6 The juice of lemons makes fine punch. <NA> <NA>
#> # ... with 714 more rows

#Replacing Matches

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
#> [1] "-pple" "p-ar" "b-nana"
str_replace_all(x, "[aeiou]", "-")
#> [1] "-ppl-" "p--r" "b-n-n-"

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
#> [1] "one house" "two cars" "three people"

sentences %>%
str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>%
head(5)
#> [1] "The canoe birch slid on the smooth planks."
#> [2] "Glue sheet the to the dark blue background."
#> [3] "It's to easy tell the depth of a well."
#> [4] "These a days chicken leg is a rare dish."
#> [5] "Rice often is served in round bowls."

#Splitting
sentences %>%
head(5) %>%
str_split(" ")
#> [[1]]
#> [1] "The" "birch" "canoe" "slid" "on" "the"
#> [7] "smooth" "planks."
#>
#> [[2]]
#> [1] "Glue" "the" "sheet" "to"
#> [5] "the" "dark" "blue" "background."
#>
#> [[3]]
#> [1] "It's" "easy" "to" "tell" "the" "depth" "of"
#> [8] "a" "well."
#>
#> [[4]]
#> [1] "These" "days" "a" "chicken" "leg" "is"
#> [7] "a" "rare" "dish."
#>
#> [[5]]
#> [1] "Rice" "is" "often" "served" "in" "round"
#> [7] "bowls."

"a|b|c|d" %>%
str_split("\\|") %>%
.[[1]]
#> [1] "a" "b" "c" "d"

sentences %>%
head(5) %>%
str_split(" ", simplify = TRUE)
#> [,1] [,2] [,3] [,4] [,5] [,6] [,7]
#> [1,] "The" "birch" "canoe" "slid" "on" "the" "smooth"
#> [2,] "Glue" "the" "sheet" "to" "the" "dark" "blue"
#> [3,] "It's" "easy" "to" "tell" "the" "depth" "of"
#> [4,] "These" "days" "a" "chicken" "leg" "is" "a"
#> [5,] "Rice" "is" "often" "served" "in" "round" "bowls."
#> [,8] [,9]
#> [1,] "planks." ""
#> [2,] "background." ""
#> [3,] "a" "well."
#> [4,] "rare" "dish."
#> [5,] "" ""

fields <- c("Name: Hadley", "Country: NZ", "Age: 35")
fields %>% str_split(": ", n = 2, simplify = TRUE)
#> [,1] [,2]
#> [1,] "Name" "Hadley"
#> [2,] "Country" "NZ"
#> [3,] "Age" "35"

x <- "This is a sentence. This is another sentence."
str_view_all(x, boundary("word"))

str_split(x, " ")[[1]]
#> [1] "This" "is" "a" "sentence." ""
#> [6] "This"
#> [7] "is" "another" "sentence."
str_split(x, boundary("word"))[[1]]
#> [1] "This" "is" "a" "sentence" "This"
#> [6] "is"
#> [7] "another" "sentence"

#Other Types of Patterns

# The regular call:
str_view(fruit, "nana")
# Is shorthand for
str_view(fruit, regex("nana"))

bananas <- c("banana", "Banana", "BANANA")
str_view(bananas, "banana")

str_view(bananas, regex("banana", ignore_case = TRUE))

x <- "Line 1\nLine 2\nLine 3"
str_extract_all(x, "^Line")[[1]]
#> [1] "Line"
str_extract_all(x, regex("^Line", multiline = TRUE))[[1]]
#> [1] "Line" "Line" "Line"

phone <- regex("
\\(? # optional opening parens
(\\d{3}) # area code
[)- ]? # optional closing parens, dash, or space
(\\d{3}) # another three numbers
[ -]? # optional space or dash
(\\d{3}) # three more numbers
", comments = TRUE)
str_match("514-791-8141", phone)
#> [,1] [,2] [,3] [,4]
#> [1,] "514-791-814" "514" "791" "814"

microbenchmark::microbenchmark(
fixed = str_detect(sentences, fixed("the")),
regex = str_detect(sentences, "the"),
times = 20
)
#> Unit: microseconds
#> expr min lq mean median uq max neval cld
#> fixed 116 117 136 120 125 389 20 a
#> regex 333 337 346 338 342 467 20 b

a1 <- "\u00e1"
a2 <- "a\u0301"
c(a1, a2)
#> [1] "á" "á"

a1 == a2
#> [1] FALSE

str_detect(a1, fixed(a2))
#> [1] FALSE
str_detect(a1, coll(a2))
#> [1] TRUE

# That means you also need to be aware of the difference
# when doing case-insensitive matches:
i <- c("I", "İ", "i", "ı")
i
#> [1] "I" "İ" "i" "ı"
str_subset(i, coll("i", ignore_case = TRUE))
#> [1] "I" "i"
str_subset(
i,
coll("i", ignore_case = TRUE, locale = "tr")
)
#> [1] "İ" "i"

stringi::stri_locale_info()
#> $Language
#> [1] "en"
#>
#> $Country
#> [1] "US"
#>
#> $Variant
#> [1] ""
#>
#> $Name
#> [1] "en_US"

x <- "This is a sentence."
str_view_all(x, boundary("word"))

str_extract_all(x, boundary("word"))
#> [[1]]
#> [1] "This" "is" "a" "sentence"

#Other Uses of Regular Expressions
apropos("replace")
#> [1] "%+replace%" "replace" "replace_na"
#> [4] "str_replace" "str_replace_all" "str_replace_na"
#> [7] "theme_replace"

head(dir(pattern = "\\.Rmd$"))
#> [1] "communicate-plots.Rmd" "communicate.Rmd"
#> [3] "datetimes.Rmd" "EDA.Rmd"
#> [5] "explore.Rmd" "factors.Rmd"


