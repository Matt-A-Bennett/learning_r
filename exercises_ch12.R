### creating factors ##########################################################
# 1. Explore the distribution of rincome (reported income). What makes the
# default bar chart hard to understand? How could you improve the plot?

gss_cat %>%
    ggplot(aes(x = rincome)) +
           geom_bar() +
           coord_flip()

# 2. What is the most common relig in this survey? What’s the most common
# partyid ?
gss_cat %>%
    count(relig, sort = T)

gss_cat %>%
    count(partyid, sort = T)

# 3. Which relig does denom (denomination) apply to? How can you find out with
# a table? How can you find out with a visualization?
gss_cat %>%
    filter(denom != "No denomination" & denom != "Not applicable") %>%
    count(relig, sort = T)
