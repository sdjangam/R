#Cleanup environment
rm(list = ls())
# free memory
gc()
setwd("C:/Users/gmanish/Downloads/openminds/code/R/")
library(tidyverse)
mpg

#Do cars with big engines use more fuel than cars with small engines?
ggplot(data = mpg)+geom_point(mapping = aes(x = displ, y = hwy))
#color
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = class))
#size
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = class))
#alpha
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
#shape
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#setting properties of the geom
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
#facet_wrap
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2)
#facet_grid with 2 variables.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ cyl)
#facet_grid with 1 variable.
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(cyl ~ . )
#geom_point vs geom_smooth
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
#changing line type.
ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
#You can set the group aesthetic to a categorical variable to draw multiple objects.
ggplot(data = mpg) +
geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
geom_smooth(
mapping = aes(x = displ, y = hwy, color = drv),
show.legend = FALSE
)

#Multiple geoms in same plot
ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy)) +
geom_smooth(mapping = aes(x = displ, y = hwy))
#setting global mappings
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
geom_point() +
geom_smooth()
#setting global and local mappings
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
geom_point(mapping = aes(color = class)) +
geom_smooth()
#overriding global mappings (data)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
geom_point(mapping = aes(color = class)) +
geom_smooth(
data = filter(mpg, class == "subcompact"),
se = FALSE
)

#bar plots
ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut))

#geoms and stats
ggplot(data = diamonds) +
stat_count(mapping = aes(x = cut))

#plot your own stat
library(tibble)
demo <- tribble(
~a, ~b,
"bar_1", 20,
"bar_2", 30,
"bar_3", 40
)
ggplot(data = demo) +
geom_bar(
mapping = aes(x = a, y = b), stat = "identity"
)

#proportion instead of count for bar plot

ggplot(data = diamonds) +
geom_bar(
mapping = aes(x = cut, y = ..prop.., group = 1)
)

#plot stat summary
ggplot(data = diamonds) +
stat_summary(
mapping = aes(x = cut, y = depth),
fun.ymin = min,
fun.ymax = max,
fun.y = median
)

#Position Adjustments
ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut, color = cut))

ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut, fill = cut))

#Stacked colored bar charts
ggplot(data = diamonds) +
geom_bar(mapping = aes(x = cut, fill = clarity))

#position=identity
ggplot(
data = diamonds,
mapping = aes(x = cut, fill = clarity)
) +
geom_bar(alpha = 1/5, position = "identity")
ggplot(
data = diamonds,
mapping = aes(x = cut, color = clarity)
) +
geom_bar(fill = NA, position = "identity")

#position=fill
ggplot(data = diamonds) +
geom_bar(
mapping = aes(x = cut, fill = clarity),
position = "fill"
)

#position=dodge
ggplot(data = diamonds) +
geom_bar(
mapping = aes(x = cut, fill = clarity),
position = "dodge"
)

#position=jitter
ggplot(data = mpg) +
geom_point(
mapping = aes(x = displ, y = hwy),
position = "jitter"
)

#flipping coordinate systems
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
geom_boxplot() +
coord_flip()

#sets the aspect ratio correctly for maps
nz <- map_data("nz")
ggplot(nz, aes(long, lat, group = group)) +
geom_polygon(fill = "white", color = "black")
ggplot(nz, aes(long, lat, group = group)) +
geom_polygon(fill = "white", color = "black") +
coord_quickmap()

#uses polar coordinates
bar <- ggplot(data = diamonds) +
geom_bar(
mapping = aes(x = cut, fill = cut),
show.legend = FALSE,
width = 1
) +
theme(aspect.ratio = 1) +
labs(x = NULL, y = NULL)
bar + coord_flip()
bar + coord_polar()

