### creating factors ##########################################################
# 1. What happens if you parse a string that contains invalid dates?
# ymd(c("2010-10-10", "bananas")) ANS: coerced to NA, with warning

# 2. What does the tzone argument to today() do? Why is it important? ANS:
# controls the timezone used.

# 3. Use the appropriate lubridate function to parse each of the following
# dates:
d1 <- mdy("January 1, 2010")
d2 <- ymd("2015-Mar-07")
d3 <- dmy("06-Jun-2017")
d4 <- mdy(c("August 19 (2015)", "July 1 (2015)"))
d5 <- mdy("12/30/14") # Dec 30, 2014

### date-time components ######################################################
# 1. How does the distribution of flight times within a day change over the
# course of the year?

make_datetime_100 <- function(year, month, day, time) {
    return (make_datetime(year, month, day, time %/% 100, time %% 100))
}

flights_dt <- flights %>%
    filter(!is.na(dep_time) & !is.na(arr_time)) %>%
    mutate(
           dep_time = make_datetime_100(year, month, day, dep_time),
           arr_time = make_datetime_100(year, month, day, arr_time),
           sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
           sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%
    select(origin, dest, ends_with("delay"), ends_with("time"))

flights_dt %>% 
    mutate(min = minute(time_hour)) %>%
    group_by(min) %>%
    count()


# 2. Compare dep_time , sched_dep_time , and dep_delay . Are they consistent?
# Explain your findings.
lims <- as.POSIXct(strptime(c("2013-01-01 00:00","2013-01-02 00:00"), format = "%Y-%m-%d %H:%M"))    
flights_dt %>%
    filter(year(arr_time) == 2013) %>%
    mutate(dep_time = update(dep_time, yday = 1),
    sched_dep_time = update(sched_dep_time, yday = 1),
    arr_time = update(arr_time, yday = 1)) %>%
    ggplot(aes(sched_dep_time, dep_time)) +
    geom_point() +
    scale_x_datetime(limits = lims) +
    scale_y_datetime(limits = lims)

flights_dt %>%
    mutate(theory_dep_time = dep_time - sched_dep_time + dep_delay) %>%
    ggplot() +
    geom_histogram(aes(theory_dep_time), binwidth = 10) +
    xlim(-2000, 5000)

# 3. Compare air_time with the duration between the departure and arrival.
# Explain your findings. (Hint: consider the location of the airport.)
flights_dt %>%
    mutate(naive_air_time = as.double(arr_time - dep_time)) %>%
    ggplot() +
    geom_histogram(aes(naive_air_time), binwidth = 1)

# 4. How does the average delay time change over the course of a day? Should
# you use dep_time or sched_dep_time ? Why?
flights_dt %>%
    mutate(dep_hour = hour(sched_dep_time)) %>%
    group_by(dep_hour) %>%
    summarise(av_mins_delay = mean(arr_delay, na.rm = T)) %>%
    ggplot(aes(dep_hour, av_mins_delay)) +
    geom_point() +
    geom_smooth()


# 5. On what day of the week should you leave if you want to minimize the
# chance of a delay? ANS: if a delay counts as anything over 5 mins, then the
# best chance of experiencing no delay is to fly on Saturday (and it's stable
# across smaller/larger delays too), and next best is Sunday.
flights_dt %>%
    mutate(wday = wday(arr_time, label = T)) %>%
    group_by(wday) %>%
    summarise(prop_delayed = sum(arr_delay > 5, na.rm = T)/n())


# 6. What makes the distribution of diamonds$carat and flights$sched_dep_time
# similar? ANS: numerous high points, which are separated along the x axis.

diamonds %>%
    filter(carat < 3) %>%
    ggplot(aes(carat)) +
    geom_histogram(binwidth = 0.01)

flights %>%
    ggplot(aes(sched_dep_time)) +
    geom_histogram(binwidth = 10)

# 7. Confirm my hypothesis that the early departures of flights in minutes
# 20–30 and 50–60 are caused by scheduled flights that leave early. Hint:
# create a binary variable that tells you whether or not a flight was delayed.

flights_dt %>%
    mutate(early = dep_time < sched_dep_time, minute = minute(dep_time)) %>%
    group_by(minute) %>%
    summarise(prop_early = mean(early)) %>%
    ggplot(aes(minute, prop_early)) +
    geom_point() +
    geom_line() +
    geom_smooth()

### time spans ################################################################
# 1. Why is there months() but no dmonths() ? ANS: becuase months are
# particularly dumb.

# 2. Explain days(overnight * 1) to someone who has just started learning R.
# How does it work? ANS: Seems like there was an update to remove this quirk


flights_dt_1 <- flights_dt %>%
    mutate(
           overnight = arr_time < dep_time,
           arr_time = arr_time + days(overnight),
           sched_arr_time = sched_arr_time + days(overnight)
    )

flights_dt_2 <- flights_dt %>%
    mutate(
           overnight = arr_time < dep_time,
           arr_time = arr_time + days(overnight * 1),
           sched_arr_time = sched_arr_time + days(overnight * 1)
    )

flights_dt_1 %>%
    filter(overnight, arr_time < dep_time)

flights_dt_2 %>%
    filter(overnight, arr_time < dep_time)

# 3. Create a vector of dates giving the first day of every month in 2015.
# Create a vector of dates giving the first day of every month in the current
# year.
ymd("2015, 01, 01") + months(0:11)
floor_date(today(), "year") + months(0:11)

# 4. Write a function that, given your birthday (as a date), returns how old
# you are in years.
age <- function(birthday) {
    diff = (birthday %--% today()) / years(1)
    return(diff)
}

birthday <- dmy("19-11-1989")
age(birthday)


# 5. Why can’t the following work? ANS: missing paren, and months(1) doesn't
# contain how long the interval is
(today() %--% (today() + years(1))) / months(1) 
