
# 1. Explore the distribution of each of the x , y , and z variables in
# diamonds . What do you learn? Think about a diamond and how you might decide
# which dimension is the length, width, and depth. ANS: x and y are similiar
# while z is different. Thus, z is probably the height of the diamond and x and
# y are the width and depth.
diamonds %>%
    filter(x<10 & y<10 & z<10) %>%
    pivot_longer(c(x,y,z), names_to='dimension', values_to='length') %>%
    ggplot() +
    geom_histogram(aes(x=length), binwidth=0.05) +
    facet_wrap(~dimension, nrow=3)

# 2. Explore the distribution of price. Do you discover anything unusual or
# surprising? (Hint: carefully think about the bin width and make sure you try
# a wide range of values.)

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you think
# is the cause of the difference?

# 4. Compare and contrast coord_cartesian() versus xlim() or ylim() when
# zooming in on a histogram. What happens if you leave binwidth unset? What
# happens if you try and zoom so only half a bar shows?
