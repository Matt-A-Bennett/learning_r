# install.packages("gamair")

library(nycflights13)
library(tidyverse)
library(Lahman)
source("../functions.R")

options(width = 160)

colnames(flights)
cl()

print(not_cancelled, width=Inf)
