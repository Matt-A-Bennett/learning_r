# install.packages("gamair")

# library(mgcv)

library(nycflights13)
library(tidyverse)
source("../functions.R")

# print the tibble
nycflights13::flights

print('Exercises 5.2.4')
    # Had an arrival delay of two or more hours
    filter(flights, dep_delay>120 & arr_delay>120)
    # Flew to Houston (IAH or HOU)
    filter(flights, dest=='IAH' | dest=='HOU')
    # Were operated by United, American, or Delta
    filter(flights, carrier %in% c('UA', 'AA', 'DL'))
    # Departed in summer (July, August, and September)
    filter(flights, month %in% c(7,8,9))
    filter(flights, between(month, 7, 9))
    # Arrived more than two hours late, but didn’t leave late
    filter(flights, dep_delay<=0 & arr_delay>120)
    # Were delayed by at least an hour, but made up over 30 minutes in flight
    filter(flights, arr_delay>=60 & (dep_delay-arr_delay)>30)
    # Departed between midnight and 6am (inclusive)
    filter(flights, dep_time<=0600)
    filter(flights, between(dep_time, 0000, 0600))
    # what does 'between()' do? use it above where possible
    # how many cancelled flights
    cancelled = filter(flights, is.na(dep_time))
    # NA ^ 0 is 1, NA * 0 is NA
    # because any number ^ 0 is 1 (even Inf), but Inf * 0 is not 0, it's undefined

print('Exercises 5.3.1')
    # How could you use arrange() to sort all missing values to the start?
    # (Hint: use is.na()).
    df <- tibble(x=c(5,NA,2))
    arrange(df, desc(is.na(x)))
    # Sort flights to find the most delayed flights. Find the flights that left
    # earliest.
     arrange(flights, arr_delay)
     arrange(flights, dep_time)
    # Sort flights to find the fastest (highest speed) flights.
     arrange(flights, distance/air_time)
    # Which flights travelled the farthest? Which travelled the shortest?
     arrange(flights, distance)

print('Exercises 5.4.1')
    # Brainstorm as many ways as possible to select dep_time, dep_delay,
    # arr_time, and arr_delay from flights.

    # What happens if you include the name of a variable multiple times in a
    # select() call?

    # What does the any_of() function do? Why might it be helpful in
    # conjunction with this vector?

    # vars <- c("year", "month", "day", "dep_delay", "arr_delay")

    # Does the result of running the following code surprise you? How do the
    # select helpers deal with case by default? How can you change that
    # default?

    # select(flights, contains("TIME"))

