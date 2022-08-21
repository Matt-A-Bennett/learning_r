### gapminder #################################################################
# 1. A linear trend seems to be slightly too simple for the overall trend. Can
# you do better with a quadratic polynomial? How can you interpret the
# coefficients of the quadratic? (Hint you might want to transform year so that
# it has mean zero.) ANS: it's better - particularly for the African countries.
# A negative coef in the quadratic term means that lifeExp is tapering (and
# even heading downwards, if it overwhelms the linear term).

# 2. Explore other methods for visualising the distribution of R2

# 3. per continent. You might want to try the ggbeeswarm package, which
# provides similar methods for avoiding overlaps as jitter, but uses
# deterministic methods.

# 4. To create the last plot (showing the data for the countries with the worst
# model fits), we needed two steps: we created a data frame with one row per
# country and then semi-joined it to the original dataset. It’s possible to
# avoid this join if we use unnest() instead of unnest(.drop = TRUE). How?

gapminder %>%
    ggplot(aes(year, lifeExp, group = country)) +
        geom_line(alpha = 0.25)

model <- function(df, form, mod = lm) {
    fit <- mod(form, data = df)
    return (fit)
}

by_country <- gapminder %>%
    group_by(country, continent) %>%
    nest() %>%
    mutate(model = map(data, ~model(., formula(lifeExp ~ year), lm))) %>%
    # mutate(model = map(data, ~model(., formula(lifeExp ~ poly(year - mean(year), 2)), lm))) %>%
    mutate(pred = map2(data, model, add_predictions)) %>%
    mutate(resid = map2(data, model, add_residuals))

preds <- unnest(by_country, pred)
resids <- unnest(by_country, resid)

resids %>% 
    ggplot(aes(year, resid)) +
        geom_line(aes(, group = country), alpha = 0.25) +
        geom_smooth(se = F) +
        facet_wrap(~ continent)

preds %>% 
    ggplot(aes(year, pred)) +
        geom_line(aes(, group = country), alpha = 0.25) +
        geom_smooth(se = F) +
        facet_wrap(~ continent)

by_country %>%
    mutate(glance = map(model, glance)) %>%
    unnest(glance) %>%
    filter(r.squared > 0.25) %>%
    # ggplot(aes(y = r.squared, group = continent)) +
    # geom_boxplot()
    # ggplot(aes(x = r.squared, color = continent)) +
    # geom_freqpoly()
    ggplot(aes(x = continent, y = r.squared)) +
    geom_beeswarm()

by_country %>%
    mutate(glance = map(model, glance)) %>%
    unnest(glance) %>%
    unnest(data) %>%
    filter(r.squared < 0.25) %>%
    ggplot(aes(year, lifeExp, color = country)) +
    geom_line()

### creating list columns #####################################################
# 1. List all the functions that you can think of that take an atomic vector
# and return a list. ANS: stc_c(), quantile()... lots more

# 2. Brainstorm useful summary functions that, like quantile() , return
# multiple values. ANS: there must be several that return confidence intervals

# 3. What’s missing in the following data frame? How does quantile() return
# that missing piece? Why isn’t that helpful here? ANS: quantile() doesn't
# return the default probs along with the samples

mtcars %>%
    group_by(cyl) %>%
    summarize(q = list(quantile(mpg))) %>%
    unnest(q)

# 4. What does this code do? Why might might it be useful? ANS: puts all
# observations (for each var, for each group) into a list - you could iterate
# over the var, passing a list per iteration to some function via map

head(mtcars)

two <- mtcars %>%
    group_by(cyl) %>%
    summarise_all(list(list))

### simplifying list-columns ##################################################
# 1 .Why might the lengths() function be useful for creating atomic vector
# columns from list-columns?

# 2 .List the most common types of vector found in a data frame. What makes
# lists different? ANS, character, numeric (int, double), logical, factor. List
# vectors can contain different types, and each element can also be a list
