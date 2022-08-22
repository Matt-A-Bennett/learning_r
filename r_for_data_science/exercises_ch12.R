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

### modifying factor orde #####################################################
# 1. There are some suspiciously high numbers in tvhours . Is the mean‐ a good
# summary?
gss_cat %>%
    # group_by(relig) %>%
    # summarize(
    #           tvhours = mean(tvhours, na.rm = T),
    #           n = n()
    #           ) %>%
    ggplot(aes(tvhours, fct_reorder(relig, tvhours))) +
    geom_boxplot()

# 2. For each factor in gss_cat identify whether the order of the levels is
# arbitrary or principled.
levels(gss_cat$marital) # arbitrary
levels(gss_cat$race)    # arbitrary
levels(gss_cat$rincome) # principled
levels(gss_cat$partyid) # principled
levels(gss_cat$relig)   # arbitrary
levels(gss_cat$denom)   # arbitrary

# 3. Why did moving “Not applicable” to the front of the levels move it to the
# bottom of the plot? ANS: because first-last factors are plotted from bottom
# to top on the Y axis...

### modifying factor levels ###################################################
# 1. How have the proportions of people identifying as Democrat, Republican,
# and Independent changed over time?
gss_cat %>%
    mutate(partyid = fct_collapse(partyid,
      "democrat" = c("Not str democrat", "Strong democrat"),
      "republican" = c("Not str republican", "Strong republican"),
      "independent" = c("Ind,near dem", "Ind,near rep", "Independent"))) %>%
    filter(partyid %in% c("democrat", "republican", "independent")) %>%
    group_by(year) %>%
    mutate(year_total = n()) %>%
    group_by(year, partyid) %>%
    mutate(prop = n()/year_total) %>%
    ggplot(aes(year, prop, color=partyid)) +
    geom_line() +
    geom_point()

# 2. How could you collapse rincome into a small set of categories?
gss_cat %>%
    mutate(rincome = fct_lump(rincome, n = 8)) %>%
    group_by(rincome) %>%
    count()

    
