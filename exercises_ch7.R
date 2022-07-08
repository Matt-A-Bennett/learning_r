### tibbles with tibble #######################################################
# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars,
# which is a regular data frame.)

# 2. Compare and contrast the following operations on a data.frame and
# equivalent tibble. What is different? Why might the default data frame
# behaviors cause you frustration?

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

# 3. If you have the name of a variable stored in an object, e.g., var <- "mpg"
# how can you extract the reference variable from a tibble?

# 4. Practice referring to nonsyntactic names in the following data frame by:
# a. Extracting the variable called 1 .
# b. Plotting a scatterplot of 1 versus 2 .
# c. Creating a new column called 3 , which is 2 divided by 1 .
# d. Renaming the columns to one , two , and three :

annoying <- tibble(
                   `1` = 1:10,
                   `2` = `1` * 2 + rnorm(length(`1`))
)

# 5. What does tibble::enframe() do? When might you use it?

# 6. What option controls how many additional column names are printed at the
# footer of a tibble?

