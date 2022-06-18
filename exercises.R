# install.packages("gamair")

# library(mgcv)

library(nycflights13)
library(tidyverse)
source("../functions.R")

# print the tibble
nycflights13::flights
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay))

print('Exercises 5.2.4 (filter)')
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

print('Exercises 5.3.1 (arrange)')
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

print('Exercises 5.4.1 (select)')
    # Brainstorm as many ways as possible to select dep_time, dep_delay,
    # arr_time, and arr_delay from flights.
    select(flights, dep_time, dep_delay, arr_time, arr_delay)
    select(flights, starts_with('dep'), starts_with('arr'))
    select(flights, matches('^[a-z]{3}_[a-z]{3}[a-z]'))
    # What happens if you include the name of a variable multiple times in a
    # select() call? ANS: it only appears once
    select(flights, dep_time, dep_time, arr_time, dep_time)
    # What does the any_of() function do? Why might it be helpful in
    # conjunction with this vector? ANS: selects any vars in a character
    # vector, (ignoring missing vars). Find seasonal variation in flight delays
    vars <- c('dep_time', 'dep_delay', 'arr_time', 'arr_delay')
    select(flights, any_of(vars))
    # vars <- c("year", "month", "day", "dep_delay", "arr_delay")
    # Does the result of running the following code surprise you? How do the
    # select helpers deal with case by default? How can you change that
    # default? ANS: I am, they ignore case by default.
    select(flights, contains("TIME", ignore.case=FALSE))

print('Exercises 5.5.2 (mutate)')
    # Currently dep_time and sched_dep_time are convenient to look at, but hard
    # to compute with because they’re not really continuous numbers. Convert
    # them to a more convenient representation of number of minutes since
    # midnight.
    mutate(flights,
           dep_time = dep_time / 100 * 60,
           sched_dep_time = sched_dep_time / 100 * 60)
    # Compare air_time with arr_time - dep_time. What do you expect to see?
    # What do you see? What do you need to do to fix it?
    mutate(flights,
           air_time = arr_time - dep_time)
    # Compare dep_time, sched_dep_time, and dep_delay. How would you expect
    # those three numbers to be related? ANS: They're very wrong but I can't
    # tell how the were generated...
    mutate(flights,
           dep_time = dep_time / 100 * 60,
           sched_dep_time = sched_dep_time / 100 * 60) %>%
    select(flights, contains('dep')) %>%
    arrange(desc(dep_delay))
    # Find the 10 most delayed flights using a ranking function. How do you
    # want to handle ties? Carefully read the documentation for min_rank().
    arrange(flights, desc(min_rank(arr_delay)), desc(min_rank(dep_delay)))
    # What does 1:3 + 1:10 return? Why? ANS: shorter vector is repeated such
    # that it matches in length
    # What trigonometric functions does R provide? ANS: defaults to degrees,
    # rather that radians... gives the sin, cos, tan + their inverses, atan2,
    # and versions for taking some proportion of pi (i.e. do things in radians)

not_cancelled %>%
    group_by(year, month, day) %>%
    summarize(mean = mean(dep_delay), median = median(dep_delay)) %>%
    arrange(desc(median))

delays <- not_cancelled %>%
    group_by(tailnum) %>%
    summarize(
              delay = mean(arr_delay, na.rm = TRUE),
              n = n()
    )

delays %>% 
    filter(n > 25) %>%
    ggplot(mapping = aes(x = delay, y = n)) +
    geom_point(alpha = 1/10)

print('Exercises 5.6.7 (grouped summaries)')
    # Brainstorm at least five different ways to assess the typical delay
    # characteristics of a group of flights. Consider the following sce‐

    # • A flight is 15 minutes early 50% of the time, and 15 minutes late 50%
    # of the time.

    # • A flight is always 10 minutes late.

    # • A flight is 30 minutes early 50% of the time, and 30 minutes late 50%
    # of the time.

    # • 99% of the time a flight is on time. 1% of the time it’s 2 hours late.

    # Which is more important: arrival delay or departure delay?

    # 2. Come up with another approach that will give you the same output as
    # not_cancelled %>% count(dest) and not_cancel led %>% count(tailnum, wt =
    # distance) (without using count() ).

    # 3. Our definition of cancelled flights ( is.na(dep_delay) |
    # is.na(arr_delay)) is slightly suboptimal. Why? Which is the most
    # important column?

    # 4. Look at the number of cancelled flights per day. Is there a pat‐ tern?
    # Is the proportion of cancelled flights related to the average delay?

    # 5. Which carrier has the worst delays? Challenge: can you disen‐ tangle
    # the effects of bad airports versus bad carriers? Why/why not? (Hint:
    # think about flights %>% group_by(carrier, dest) %>% summarize(n()) .)

    # 6. For each plane, count the number of flights before the first delay of
    # greater than 1 hour.

    # 7. What does the sort argument to count() do? When might you use it?

print('Exercises 5.7.1 (grouped mutates and filters)')


