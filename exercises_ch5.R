### distributions #############################################################

# 1. Explore the distribution of each of the x , y , and z variables in
# diamonds . What do you learn? Think about a diamond and how you might decide
# which dimension is the length, width, and depth. ANS: x and y are similiar
# while z is different. Thus, z is probably the height of the diamond and x and
# y are the width and depth.
diamonds %>%
    pivot_longer(c(x,y,z), names_to='dimension', values_to='length') %>%
    filter(length > 2 & length < 10) %>%
    ggplot() +
    geom_histogram(aes(x=length), binwidth=0.05) +
    facet_wrap(~dimension, nrow=3)

# 2. Explore the distribution of price. Do you discover anything unusual or
# surprising? (Hint: carefully think about the bin width and make sure you try
# a wide range of values.) ANS: no diamonds priced between 1459 and 1541
diamonds %>%
    ggplot() +
    geom_histogram(aes(x=price), binwidth=10) +
    coord_cartesian(xlim=c(1000, 2000))

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think
# is the cause of the difference? ANS: not sure why - maybe rounding up to sell
# for more money?
diamonds %>%
    summarize(`0.99` = sum(carat==0.99),
              `1`    = sum(carat==1))

diamonds %>%
    ggplot() +
    geom_histogram(aes(x=carat), binwidth=0.01) +
    coord_cartesian(xlim=c(0.99, 1))


# 4. Compare and contrast coord_cartesian() versus xlim() or ylim() when
# zooming in on a histogram. What happens if you leave binwidth unset? What
# happens if you try and zoom so only half a bar shows? ANS: xlim() affects the
# bins - they filter the data outside of the lims before making the histogram,
# coord_cartesian() simply keeps zooming in.
diamonds %>%
    ggplot() +
    geom_histogram(aes(x=price)) +
    coord_cartesian(xlim=c(1400, 1600))

diamonds %>%
    ggplot() +
    geom_histogram(aes(x=price)) +
    xlim(1453, 1455)


### missing values ############################################################

# 1. What happens to missing values in a histogram? What happens to missing
# values in a bar chart? Why is there a difference? ANS: histogram drops them,
# bar treats them as a new category. Because histogram takes numerical data (so
# NA doesn't count)
diamonds %>%
    filter(y > 3 & y < 20) %>%
    mutate(y = ifelse(y>4, NA, y)) %>%
    ggplot() +
    geom_histogram(aes(x=y))

diamonds %>%
    mutate(cut = ifelse(cut=='Good', NA, 'Good')) %>%
    ggplot() +
    geom_bar(aes(x=cut))

# 2. What does na.rm = TRUE do in mean() and sum() ? ANS: applies the function
# just to the non NA values
flights %>%
    summarize(mean(dep_delay, na.rm = T))

flights %>%
    summarize(sum(dep_delay, na.rm = T))

### a categorical and continuous variable #####################################
# 1. Use what you’ve learned to improve the visualization of the departure
# times of cancelled versus noncancelled flights.

# 2. What variable in the diamonds dataset is most important for predicting the
# price of a diamond? How is that variable correlated with cut? Why does the
# combination of those two relationships lead to lower quality diamonds being
# more expensive?

# 3. Install the ggstance package, and create a horizontal boxplot. How does
# this compare to using coord_flip() ?

# 4. One problem with boxplots is that they were developed in an era of much
# smaller datasets and tend to display a prohibitively large number of
# “outlying values.” One approach to remedy this problem is the letter value
# plot. Install the lvplot package, and try using geom_lv() to display the
# distribution of price versus cut. What do you learn? How do you interpret the
# plots?

# 5. Compare and contrast geom_violin() with a faceted geom_his togram() , or a
# colored geom_freqpoly() . What are the pros and cons of each method?

# 6. If you have a small dataset, it’s sometimes useful to use geom_jitter() to
# see the relationship between a continuous and categorical variable. The
# ggbeeswarm package provides a number of methods similar to geom_jitter() .
# List them and briefly describe what each one does.


