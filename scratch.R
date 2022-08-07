library(tidyverse)
library(stringr)
library(nycflights13)
library(Lahman)
library(ggdark)
library(glue)
source("../functions.R")
options(width = 158)

theme_set(dark_theme_gray(base_size = 28)
          + theme(plot.background = element_rect(fill = "grey10"),
                  panel.grid.major = element_line(color = "grey30", size = 0.2),
                  panel.grid.minor = element_line(color = "grey30", size = 0.2)))

cl()

str <- c("a", "b", "c", "d", "e")
