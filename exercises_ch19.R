### gapminder #################################################################
# 1. A linear trend seems to be slightly too simple for the overall trend. Can
# you do better with a quadratic polynomial? How can you interpret the
# coefficients of the quadratic? (Hint you might want to transform year so that
# it has mean zero.)

# 2. Explore other methods for visualising the distribution of R2

# 3. per continent. You might want to try the ggbeeswarm package, which
# provides similar methods for avoiding overlaps as jitter, but uses
# deterministic methods.

# 4. To create the last plot (showing the data for the countries with the worst
# model fits), we needed two steps: we created a data frame with one row per
# country and then semi-joined it to the original dataset. It’s possible to
# avoid this join if we use unnest() instead of unnest(.drop = TRUE). How?
