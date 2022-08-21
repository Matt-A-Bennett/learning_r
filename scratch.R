library(tidyverse)
library(lubridate)
library(modelr)
library(glue)
library(MASS)
library(splines)
library(broom)
library(nycflights13)
library(Lahman)
library(gapminder)
library(ggdark)
library(ggbeeswarm)
source("../functions.R")
options(width = 158)

theme_set(dark_theme_gray(base_size = 28)
          + theme(plot.background = element_rect(fill = "grey10"),
                  panel.grid.major = element_line(color = "grey30", size = 0.2),
                  panel.grid.minor = element_line(color = "grey30", size = 0.2)))

cl()
