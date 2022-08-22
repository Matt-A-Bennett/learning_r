### tibbles with tibble #######################################################
# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars,
# which is a regular data frame.) ANS: too obvious
mtcars
as_tibble(mtcars)

# 2. Compare and contrast the following operations on a data.frame and
# equivalent tibble. What is different? Why might the default data frame
# behaviors cause you frustration? ANS: data.frame tries to guess the var that
# you meant... invites mistakes.

df <- data.frame(abc = 1, xyz = "a")
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

df <- as_tibble(df)
df$x
df[, "xyz"]
df[, c("abc", "xyz")]

# 3. If you have the name of a variable stored in an object, e.g., var <- "mpg"
# how can you extract the reference variable from a tibble?

var <- "xyz"
df[,var]

# 4. Practice referring to nonsyntactic names in the following data frame by:
# a. Extracting the variable called 1 .
# b. Plotting a scatterplot of 1 versus 2 .
# c. Creating a new column called 3 , which is 2 divided by 1 .
# d. Renaming the columns to one , two , and three :

annoying <- tibble(
                   `1` = 1:10,
                   `2` = `1` * 2 + rnorm(length(`1`))
)

annoying$`1`

annoying %>%
    ggplot(aes(x = `1`, y=`2`)) +
    geom_point()

more_annoying <- annoying %>%
    mutate(`3` = `2`/`1`)

good <- more_annoying %>% 
    rename('one' = `1`, 'two' = `2`, 'three' = `3`)

# 5. What does tibble::enframe() do? When might you use it? ANS: creates a one
# or two column tibble from a vector or a list (where key value pairs form 1st
# and 2nd columns).

enframe(c(seq(10), seq(10)), name = 'john', value = 'doe')
enframe(list(one = 1, two = 2:3, three = 4:6))

# 6. What option controls how many additional column names are printed at the
# footer of a tibble? ANS: max_extra_cols


