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

# 2. Identify the keys in the following datasets:
# a. Lahman::Batting
# b. babynames::babynames
# c. nasaweather::atmos
# d. fueleconomy::vehicles
# e. ggplot2::diamonds
# (You might need to install some packages and read some documentation.)

# 3. Draw a diagram illustrating the connections between the Batting, Master,
# and Salaries tables in the Lahman package. Draw another diagram that shows
# the relationship between Mas ter, Managers, and AwardsManagers. How would you
# characterize the relationship between the Batting, Pitching, and Fielding
# tables?
