
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

print('Exercises 5.6.7 (grouped summaries)')    
    # Brainstorm at least five different ways to assess the typical delay
    # characteristics of a group of flights. Consider the following scenarios:

    # • A flight is 15 minutes early 50% of the time, and 15 minutes late 50%
    # of the time.

    # • A flight is always 10 minutes late.

    # • A flight is 30 minutes early 50% of the time, and 30 minutes late 50%
    # of the time.

    # • 99% of the time a flight is on time. 1% of the time it’s 2 hours late.

    flights %>% 
        group_by(tailnum) %>%
        mutate(n = n(), med = median(arr_delay, na.rm = TRUE)) %>%
        filter(n > 25) %>%
        ggplot(mapping = aes(x=med, y=n)) +
        geom_point()

    flights %>% 
        group_by(tailnum) %>%
        mutate(n = n(), mode_delay = mode(arr_delay)) %>%
        filter(n > 25) %>%
        select(year:day, tailnum, n, arr_delay, mode_delay) %>%
        arrange(desc(mode_delay))

    # Which is more important: arrival delay or departure delay?
    # ANS: I would say arr_delay (but obviousely depends...)

    # 2. Come up with another approach that will give you the same output as
    # not_cancelled %>% count(dest) and not_cancelled %>% count(tailnum, wt =
    # distance) (without using count() ).

    not_cancelled %>% count(dest)        
    not_cancelled %>% group_by(dest) %>% summarize(count = n())

    not_cancelled %>% count(tailnum, wt = distance)
    not_cancelled %>%
        group_by(tailnum, distance) %>%
        summarize(count = n()) %>%
        transmute(new = distance * count) %>%
        group_by(tailnum) %>%
        summarize(count = sum(new))

    # 3. Our definition of cancelled flights ( is.na(dep_delay) |
    # is.na(arr_delay)) is slightly suboptimal. Why? Which is the most
    # important column?
    # ANS: plane is not cancelled, but is redirected? dep_delay is most
    # important

    # 4. Look at the number of cancelled flights per day. Is there a pattern?
    # Is the proportion of cancelled flights related to the average delay?
    flights %>%
        mutate(cancelled =  is.na(dep_delay) | is.na(arr_delay)) %>%
        group_by(year, month, day) %>%
        summarize(n_cancelled = sum(cancelled), n_flights = n()) %>%
        ggplot(mapping=aes(x=n_flights, y=n_cancelled)) +
        geom_point()

    ggplot(data = flights, mapping=aes(x=arr_delay, y=dep_delay)) +
        geom_point(alpha = 1/10)

    flights %>%
        mutate(cancelled =  is.na(dep_delay) | is.na(arr_delay)) %>%
        group_by(year, month, day) %>%
        summarize(prop_cancelled = mean(cancelled),
                  av_dep_delay = mean(dep_delay, na.rm = TRUE),
                  av_arr_delay = mean(arr_delay, na.rm = TRUE),
                  grand_av = mean(c(av_dep_delay, av_arr_delay), na.rm = TRUE)) ->
       av_flights

    ggplot(data = av_flights, mapping=aes(y=prop_cancelled)) +
        geom_point(mapping = aes(x=av_arr_delay), colour = 'red', alpha=1/3) + 
        geom_smooth(mapping = aes(x=av_arr_delay), colour = 'red', se = FALSE) +
        geom_point(mapping = aes(x=av_dep_delay), colour = 'blue', alpha=1/3) +
        geom_smooth(mapping = aes(x=av_dep_delay), colour = 'blue', se = FALSE)

    # 5. Which carrier has the worst delays? Challenge: can you disentangle the
    # effects of bad airports versus bad carriers? Why/why not? (Hint: think
    # about flights %>% group_by(carrier, dest) %>% summarize(n()) .)
    flights %>%
        group_by(carrier, dest) %>%
        summarize(av_delay = mean(dep_delay, na.rm = TRUE), n = n()) %>%
        ggplot(mapping = aes(x=carrier, y=av_delay, size=n, group = dest, colour=dest)) +
            geom_point()

    # 6. For each plane, count the number of flights before the first delay of
    # greater than 1 hour.
    flights %>% 
        arrange(time_hour) %>%
        select(time_hour)
    
    flights %>%
        group_by(year, month, day, tailnum) %>%
        mutate(too_late = cummax(dep_delay) > 3, .after = dep_delay) %>%
        select(year:too_late) 

        ggplot(mapping = aes(x=time_hour, y=dep_delay)) +
               geom_point()

    # 7. What does the sort argument to count() do? When might you use it?
    # ANS: If ‘TRUE’, will show the largest groups at the top.

print('Exercises 5.7.1 (grouped mutate and filters)')
    # 1. Refer back to the table of useful mutate and filtering functions.
    # Describe how each operation changes when you combine it with grouping.
    # ANS: Only functions which do a collective operation over the vector will
    # respect grouping and the result is different that without grouping.
    flights %>%
        group_by(dest) %>%
        mutate(dep_time_more = log(dep_time), .after = dep_delay) %>%
        relocate(dest)

    flights %>%
        group_by(dest) %>%
        mutate(dep_time_more = dep_time + 1, .after = dep_delay) %>%
        relocate(dest)

    # 2. Which plane ( tailnum ) has the worst on-time record?
    flights %>%
        group_by(tailnum) %>%
        summarize(mean_delay = mean(arr_delay, na.rm = T), n = n()) %>%
        filter(n > 20) %>%
        filter(min_rank(desc(mean_delay)) == 1)

    # 3. What time of day should you fly if you want to avoid delays as much as
    # possible?
    flights %>%
        group_by(hour, minute) %>%
        mutate(new = hour + minute/60, del = mean(arr_delay, na.rm = T), n = n()) %>% 
        filter(n > 30) %>% 
        ggplot(mapping = aes(x=new, y=del, size = n)) + 
               geom_point(alpha = 1/10)

    # 4. For each destination, compute the total minutes of delay. For each
    # flight, compute the proportion of the total delay for its destination.
    flights %>%
        group_by(dest) %>%
        summarize(tot_del = sum(arr_delay, na.rm = T)) %>%
        arrange(desc(tot_del))

    # 5. Delays are typically temporally correlated: even once the problem that
    # caused the initial delay has been resolved, later flights are delayed to
    # allow earlier flights to leave. Using lag() explores how the delay of a
    # flight is related to the delay of the immediately preceding flight.
    flights %>%
        arrange(origin, year, month, day, dep_time) %>%
        group_by(origin) %>%
        mutate(prev = lag(dep_delay)) %>%
        filter(!is.na(dep_delay) & !is.na(prev)) -> lagged_flights

    lagged_flights %>%
        group_by(prev) %>%
        summarize(dep_delay_mean = mean(dep_delay)) %>%
        ggplot(mapping = aes(x = prev, y = dep_delay_mean)) +
            geom_point(alpha=1/2)

    # 6. Look at each destination. Can you find flights that are suspiciously
    # fast? (That is, flights that represent a potential data entry error.)
    # Compute the air time of a flight relative to the shortest flight to that
    # destination. Which flights were most delayed in the air?
    flights %>%
        group_by(dest, origin) %>%
        filter(!is.na(air_time)) %>%
        mutate(shortest = air_time[min(distance)],
               relative = air_time/shortest,
               speed = distance/air_time * 60) %>%
        relocate(dest, carrier, flight, shortest, distance, air_time, relative,
                 speed) %>%
        arrange(relative) -> air_time 
        
    air_time %>%
        ggplot(mapping = aes(x = relative)) +
        geom_histogram(binwidth = 0.02)

    air_time %>%
        ggplot(mapping = aes(x = speed)) +
        geom_histogram(binwidth = 10)

    # 7. Find all destinations that are flown by at least two carriers. Use
    # that information to rank the carriers.
    flights %>%
        group_by(dest) %>%
        mutate(n_carrier = n_distinct(carrier)) %>% 
        filter(n_carrier > 1) %>%
        select(dest, carrier, n_carrier) %>%
        arrange(desc(n_carrier), dest, carrier) %>%
        group_by(carrier) %>%
        summarize(n_dest = n_distinct(dest)) %>%
        arrange(desc(n_dest))


