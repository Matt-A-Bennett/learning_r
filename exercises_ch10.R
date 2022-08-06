### introduction ##############################################################
# 1. Imagine you wanted to draw (approximately) the route each plane flies from
# its origin to its destination. What variables would you need? What tables
# would you need to combine? ANS flight -> origin -> faa -> lat + lon -> dest
# -> faa -> lat + lon

# 2. I forgot to draw the relationship between weather and airports . What is
# the relationship and how should it appear in the diagram ANS origin <-> faa

# 3. weather only contains information for the origin (NYC) airports. If it
# contained weather records for all airports in the USA, what additional
# relation would it define with flights ? ANS: dest <-> dest

# 4. We know that some days of the year are “special,” and fewer people than
# usual fly on them. How might you represent that data as a data frame? What
# would be the primary keys of that table? How would it connect to the existing
# tables? ANS: year, month, day


### keys ######################################################################
# 1. Add a surrogate key to flights.
flights %>%
    mutate(key = row_number(), .before = 1)

# 2. Identify the keys in the following datasets:
# a. Lahman::Batting
# b. babynames::babynames
# c. nasaweather::atmos
# d. fueleconomy::vehicles
# e. ggplot2::diamonds
# (You might need to install some packages and read some documentation.)
# install.packages(c("babynames", "nasaweather", "fueleconomy"))

Batting %>%
    count(playerID, yearID, stint) %>%
    filter(n > 1)

# I think you need the first 3
babynames::babynames %>%
    count(year, sex, name, name = "amount") %>%
    filter(amount > 1)

# This works, but it's possible that an identical set of measurements could
# throw a spanner in the works...
nasaweather::atmos %>%
    count(lat, long, year, month) %>%
    filter(n > 1)
 
# has an ID already (all other vars not enough)
fueleconomy::vehicles %>%
    count(id) %>%
    # count(make, model, year, class, trans, drive, cyl, displ, fuel, hwy, cty)  %>%
    filter(n > 1)
     
# no key, would need to add with `mutate(key = row_number(), .before = 1)
ggplot2::diamonds %>%
    count(carat, cut, color, clarity, depth, table, price, x, y, z)  %>%
    filter(n > 1)


# 3. Draw a diagram illustrating the connections between the Batting, Master,
# and Salaries tables in the Lahman package. Draw another diagram that shows
# the relationship between Master, Managers, and AwardsManagers. How would you
# characterize the relationship between the Batting, Pitching, and Fielding
# tables? ANS: 
# Batting primary keys are 'playerID, yearID, stint', 
# People primary keys are 'playerID'
# Salaries primary keys are 'playerID, yearID, TeamID'
# 'PlayerID' is a foreign key for Batting and Salaries

# Managers primary keys are 'yearID, teamID, inseason', 
# People primary keys are 'PlayerID'
# AwardsManagers primary keys are 'playerID, awardID, yearID'
# 'PlayerID' is a foreign key for Managers and AwardsManagers

# Batting primary keys are 'playerID, yearID, stint', 
# Pitching primary keys are 'playerID, yearID, stint', 
# Fielding primary keys are 'playerID, yearID, stint, POS'
# 'playerID, yearID, stint' is a foreign key for Batting and Pitching
head(Batting)
head(Pitching)
head(Fielding)

Pitching %>%
    count(playerID, yearID, stint) %>%
    filter(n > 1)

### mutating joins ############################################################
# 1. Compute the average delay by destination, then join on the airports data
# frame so you can show the spatial distribution of delays. Here’s an easy way
# to draw a map of the United States:

flights <- flights %>%
    group_by(dest) %>%
    mutate(av_delay = mean(arr_delay, na.rm=T), .after=day)

airports <- airports %>%
    inner_join(flights, c("faa" = "dest")) %>%
    select(c(faa:tzone, av_delay))


airports %>%
    ggplot(aes(lon, lat, color=av_delay)) +
    borders("state") +
    geom_point() +
    coord_quickmap()

# You might want to use the size or color of the points to display the average
# delay for each airport.

# 2. Add the location of the origin and destination (i.e., the lat and lon) to
# flights.
airports_locations <- airports %>%
    select(faa, lat, lon)

flights_loc <- flights %>%
    left_join(airports_locations, c("origin" = "faa")) %>%
    left_join(airports_locations, c("dest" = "faa"),
              suffix = c("_origin", "_dest")) %>%
    select(year:day, hour, origin, dest, lat_origin:lon_dest)

# 3. Is there a relationship between the age of a plane and its delays?

flights %>%
    inner_join(planes, "tailnum") %>%
    group_by(tailnum) %>%
    mutate(av_delay = mean(arr_delay, na.rm = T), .after = day) %>%
    group_by(year.y) %>%
    mutate(year_av_delay = mean(av_delay, na.rm = T), .after = av_delay) %>%
    ggplot() +
    geom_point(aes(year.y, year_av_delay))

# 4. What weather conditions make it more likely to see a delay? ANS: most have
# an intuitive effect
df <- flights %>%
    inner_join(weather, c("origin", "year", "month", "day", "hour")) %>%
    select(year:day, arr_delay,  temp:visib)

df %>%
    group_by(wind_dir) %>%
    summarise(delay = mean(arr_delay, na.rm = T)) %>%
    ggplot(aes(wind_dir, delay)) +
    geom_point() +
    geom_smooth()
colnames(df)

# 5. What happened on June 13, 2013? Display the spatial pattern of delays, and
# then use Google to cross-reference with the weather. ANS: Derechos
airports_locations <- airports %>%
    select(faa, lat, lon)

spatial_weather <- flights %>%
    left_join(airports_locations, c("origin" = "faa")) %>%
    left_join(airports_locations, c("dest" = "faa"),
              suffix = c("_origin", "_dest")) %>% 
    inner_join(weather, c("origin", "year", "month", "day", "hour")) %>%
    select(year:day, hour, arr_delay, tailnum, origin, dest, lat_origin:lon_dest) %>%
    filter(year == 2013, month == 6, day == 13)

spatial_weather %>%
    group_by(dest) %>%
    mutate(av_delay = mean(arr_delay, na.rm = T), .after = arr_delay) %>%
    ggplot(aes(lon_dest, lat_dest, color = av_delay, size = av_delay)) +
    borders("state") +
    geom_point() +
    coord_quickmap()


### filtering joines ##########################################################
# 1. What does it mean for a flight to have a missing tailnum ? What do the
# tail numbers that don’t have a matching record in planes have in common?
# (Hint: one variable explains ~90% of the problems.)

# 2. Filter flights to only show flights with planes that have flown at least
# 100 flights.

# 3. Combine fueleconomy::vehicles and fueleconomy::common to find only the
# records for the most common models.

# 4. Find the 48 hours (over the course of the whole year) that have the worst
# delays. Cross-reference it with the weather data. Can you see any patterns?

# 5. What does anti_join(flights, airports, by = c("dest" = "faa")) tell you?
# What does anti_join(airports, flights, by = c("faa" = "dest")) tell you?

# 6. You might expect that there’s an implicit relationship between plane and
# airline, because each plane is flown by a single airline. Confirm or reject
# this hypothesis using the tools you’ve learned in the preceding section.
