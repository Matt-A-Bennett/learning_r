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





