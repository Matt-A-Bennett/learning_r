### why are low quality diamonds more expensive? ##############################
# 1. In the plot of lcarat versus lprice , there are some bright vertical
# strips. What do they represent? 
# ANS: 0.3, 0.4, 0.5, 0.7, 0.9, 1, 1.5, 2 (nice human fractions)

# 2. If log(price) = a_0 + a_1 * log(carat) , what does that say about the
# relationship between price and carat ? ANS: it's an exponetial relationship

# 3. Extract the diamonds that have very high and very low residuals. Is there
# anything unusual about these diamonds? Are they particularly bad or good, or
# do you think these are pricing errors?
diamonds2 <- diamonds %>%
    filter(carat < 2.5) %>%
    mutate(lprice = log2(price), lcarat = log2(carat))

mod1 <- lm(lprice ~ lcarat, data = diamonds2)

grid <- diamonds2 %>%
    data_grid(carat = seq_range(carat, 20)) %>%
    mutate(lcarat = log2(carat)) %>%
    add_predictions(mod1, "lprice") %>%
    mutate(price = 2 ^ lprice)

ggplot(diamonds2, aes(carat, price)) +
    geom_hex(bins = 50) +
    geom_line(data = grid, color = "red", size = 1)

diamonds2 <- diamonds2 %>% add_residuals(mod1, var = "lresid")

diamonds2 <- diamonds2 %>%
    add_predictions(mod1, "pred_lprice") %>%
    mutate("pred_price" = 2 ^ pred_lprice)

diamonds2 %>%
    arrange(desc(lresid))

ggplot(diamonds2, aes(lresid, price, color = clarity)) +
    geom_point(alpha = 0.2)

# sytmatic under/over estimate grouped by clarity and color

mod_diamond2 <- lm(
                   lprice ~ lcarat + color + cut + clarity,
                   data = diamonds2
)

diamonds2 <- diamonds2 %>% add_residuals(mod_diamond2, var = "lresid_lin")

ggplot(diamonds2, aes(lresid, price, color = clarity)) +
    geom_point(alpha = 0.2)

ggplot(diamonds2, aes(lresid_lin, color = clarity)) +
    geom_freqpoly(binwidth = 0.05)

diamonds2

# 4. Does the final model, mod_diamonds2 , do a good job of predicting diamond
# prices? Would you trust it to tell you how much to spend if you were buying a
# diamond? ANS: yes, the lprice ~ lcarat + color + cut + clarity is ok,
# especially if I was buying in bulk

### what affects the number of daily flights? #################################

term <- function(dates) {
    cut(dates, breaks = ymd(c(20130101, 20130605, 20130825, 20140101)),
        labels = c("winter", "summer", "autumn"))
}

holidays <- function(dates) {
    cut(dates, breaks = ymd(c(20130101,
                              20130525, 20130526, # Memorial Day 
                              20130703, 20130705, # July 4th
                              20130831, 20130901, # Labour Day
                              20131127, 20131129, # Thanksgiving
                                        20131201, # Thanksgiving Return
                              20131220, 20131221, # Xmas Leave
                              20131223, 20131225, # Xmas
                              20131227, 20131228, # Xmas Return
                              20131230, 20140101)), # New Years Leave
        labels = c("normal",
                   "Memorial Day",
                   "normal",
                   "July 4th",
                   "normal",
                   "Labour Day",
                   "normal",
                   "Thanksgiving Leave",
                   "Thanksgiving Return",
                   "normal",
                   "Xmas Leave",
                   "normal",
                   "Xmas",
                   "normal",
                   "New Years Leave",
                   "normal",
                   "New Years"), right = TRUE)
}

order_days <- function(days) {
    ordered(days, levels=c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
}

daily <- flights %>% 
    mutate(date = make_date(year, month, day)) %>%
    group_by(date) %>%
    count() %>%
    ungroup() %>%
    mutate(day = wday(date, label = T)) %>%
    mutate(day = order_days(day)) %>%
    mutate(term = term(date), .after = day) %>%
    mutate(dayterm = case_when(term == "winter" & day == "Sat" ~ "Sat_winter",
                               term == "summer" & day == "Sat" ~ "Sat_summer",
                               term == "autumn" & day == "Sat" ~ "Sat_autumn",
                               TRUE ~ as.character(day))) %>%
    mutate(holiday = holidays(date))

mod1 <- lm(n ~ day, data = daily)
mod2 <- lm(n ~ day * term, data = daily)
mod3 <- MASS::rlm(n ~ day * term, data = daily)
mod4 <- MASS::rlm(n ~ day * ns(date, 5), data = daily)
mod5 <- MASS::rlm(n ~ dayterm, data = daily)
mod6 <- MASS::rlm(n ~ dayterm + holiday, data = daily)
moddumb <- MASS::rlm(n ~ day * month(date), data = daily)

daily <- daily %>% 
    gather_predictions(without_term = mod1,
                       with_term = mod2,
                       with_term_mass = mod3,
                       without_term_spline = mod4,
                       custom_dayterm = mod5,
                       custom_dayterm_hol = mod6,
                       day_month = moddumb) %>%
    gather_residuals(without_term = mod1,
                     with_term = mod2,
                     with_term_mass = mod3,
                     without_term_spline = mod4,
                     custom_dayterm = mod5,
                     custom_dayterm_hol = mod6,
                     day_month = moddumb)

hol_events <- daily %>%
    filter(holiday != "normal") %>%
    distinct(date, holiday)

hol_resid <- daily %>%
    filter(model == "custom_dayterm") %>%
    distinct(date, resid) %>%
    filter(resid > 75 | resid < -150)

hol_events <- hol_events %>%
    inner_join(hol_resid, by = "date")

grid <- daily %>%
    data_grid(day, term) %>%
    add_predictions(mod2, "n")

daily %>%
    ggplot(aes(date, n)) +
    geom_line()

daily %>%
    filter(model == "without_term") %>%
    ggplot(aes(date, resid)) + 
    geom_ref_line(h = 0, colour = "black") +
    geom_line()

daily %>%
    filter(model == "without_term") %>%
    ggplot(aes(date, resid, color = day)) + 
    geom_ref_line(h = 0, colour = "black") +
    geom_line()

daily %>%
    filter(model == "without_term") %>%
    filter(day == "Sat") %>%
    ggplot(aes(date, resid, color = term)) + 
    geom_ref_line(h = 0, colour = "black") +
    geom_line() +
    geom_point()

daily %>%
    filter(model == "without_term" |
           model == "day_month") %>%
    # filter(model == "day_month") %>%
    ggplot(aes(date, resid, colour = model)) + 
    geom_ref_line(h = 0, colour = "black") +
    geom_point(alpha = 0.75) +
    geom_line(alpha = 0.75) +
    facet_wrap(~ model, ncol = 1)

ggplot(daily, aes(day, n)) +
geom_boxplot() +
geom_point(data = grid, color = "green", size = 5) +
facet_wrap(~ term)

daily %>%
    ggplot(aes(day, distance)) +
    geom_boxplot(outlier.shape = NA)

# 1. Use your Google sleuthing skills to brainstorm why there were fewer than
# expected flights on January 20, May 26, and Septem‐ ber 1. (Hint: they all
# have the same explanation.) How would these days generalize to another year?

# 2. What do the three days with high positive residuals represent? How would
# these days generalize to another year?

# 3. Create a new variable that splits the wday variable into terms, but only
# for Saturdays, i.e., it should have Thurs , Fri , but Sat-summer ,
# Sat-spring , Sat-fall . How does this model compare with the model with every
# combination of wday and term ? ANS: not much different, simpler model (thus
# better)

# 4. Create a new wday variable that combines the day of week, term (for
# Saturdays), and public holidays. What do the residuals of that model look
# like? ANS: you can target them manually and remove them from the residuals

# 5. What happens if you fit a day-of-week effect that varies by month (i.e., n
# ~ wday * month )? Why is this not very helpful? ANS: months don't sync up
# with days (they're not aliased). Also 7 * 12 params for 365 obs... 

# 6. What would you expect the model n ~ wday + ns(date, 5) to look like?
# Knowing what you know about the data, why would you expect it to be not
# particularly effective? ANS: the spline needs to interact by day, and so an
# additive model wouldn't be able to capture the differential curve for Sat and
# would instead come up with a single comprise curve and use weekday as an
# offset.

# 7. We hypothesized that people leaving on Sundays are more likely to be
# business travelers who need to be somewhere on Monday. Explore that
# hypothesis by seeing how it breaks down based on distance and time: if it’s
# true, you’d expect to see more Sunday evening flights to places that are far
# away.

# 8. It’s a little frustrating that Sunday and Saturday are on separate ends of
# the plot. Write a small function to set the levels of the factor so that the
# week starts on Monday. ANS: see code above
