### for loops #################################################################
# 1. Write for loops to:

# a. Compute the mean of every column in mtcars .
out <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
    out[[i]] <- mean(mtcars[[i]], na.rm = T)
}

# b. Determine the type flights13::flights . of each column in nyc
out <- vector("double", ncol(flights))
for (i in seq_along(flights)) {
    out[[i]] <- typeof(flights[[i]])
}

# c. Compute the number of unique values in each column of iris .
out <- vector("double", ncol(iris))
for (i in seq_along(iris)) {
    out[[i]] <- n_distinct(iris[[i]])
}

# d. Generate 10 random normals for each of μ = –10, 0, 10, and 100. Think
# about the output, sequence, and body before you start writing the loop.
mus <- c(-10, 0, 10, 100)
out <- vector("double", length(mus))
for (i in seq_along(mus)) {
    out[[i]] <- rnorm(1, i)
}

# 2. Eliminate the for loop in each of the following examples by taking
# advantage of an existing function that works with vectors:

# out <- ""
# for (x in letters) {
#     out <- stringr::str_c(out, x)
# }

str_c(letters, collapse = "")

x <- sample(100)
# sd <- 0
# for (i in seq_along(x)) {
#     sd <- sd + (x[i] - mean(x)) ^ 2
# }
# sd <- sqrt(sd / (length(x) - 1))

sd <- sqrt(var(x))


x <- runif(100)
# out <- vector("numeric", length(x))
# out[1] <- x[1]
# for (i in 2:length(x)) {
#     out[i] <- out[i - 1] + x[i]
# }
cumsum(x)


# 3. Combine your function writing and for loop skills:

pluralise <- function(word, n) {
    if (n != 1) {
        return (paste0(word, "s"))
    } else {
        return (paste0(word))
    }
}

# a. Write a for loop that prints() the lyrics to the children’s song “Alice
# the Camel.”
    n_humps <- c("no", "one", "two", "three", "four", "five")
for (i in length(n_humps):1) {
    for (j in 1:3) {
        print(glue("Alice the camel has {n_humps[[i]]} {pluralise('hump', i-1)}."))
    }
    print(glue("So go, Alice go!"))
    print(glue("Boom, boom, boom, boom!\n\n"))
}
print(glue("'Cause Alice is a horse of course!"))
print(glue("...how was that obvious?!"))

# b. Convert the nursery rhyme “Ten in the Bed” to a function. Generalize it to
# any number of people in any sleeping structure.
verse <- function(n_in_bed, sleeping_structure = "bed") {
    n <- c("one", "two", "three", "four", "five")
    stopifnot(n_in_bed <= length(n))
    for (i in n_in_bed:1) {
        if (i > 1) was_were = "were" else was_were = "was"
        print(glue('There {was_were} {n[[i]]} in the {sleeping_structure}'))
        print(glue('And the little one said,'))
        if (i == 1) {
            print(glue("Good night!"))
        } else {
            print(glue('"Roll over! Roll over!"'))
            print(glue('So they all rolled over'))
            print(glue('And one fell out'))
        }
        print(glue("\n"))
    }
}
verse(1, "hammock")

# c. Convert the song “99 Bottles of Beer on the Wall” to a function.
# Generalize to any number of any vessel containing any liquid on any surface.

n_surfaces_of_liquid_on_the_wall <- function(liquid = "beer", surface = "bottle", n = 99) {
    for (n in n_bottles:1) {
        print(glue("{n} {pluralise(surface, n)} of {liquid} on the wall, {n} {pluralise(surface, n)} of {liquid}."))
        print(glue("Take one down and pass it around, {n-1} {pluralise(surface, n-1)} of {liquid} on the wall."))
        print(glue("\n"))
    }
    print(glue("No more {surface}s of {liquid} on the wall, no more {surface}s of {liquid}."))
    print(glue("Go to the store and buy some more, 99 {surface}s of {liquid} on the wall."))
}
n_surfaces_of_liquid_on_the_wall(liquid = "water", surface = "cup", n = 2)

# 4. It’s common to see for loops that don’t preallocate the output and instead
# increase the length of a vector at each step:

for (i in 1:5) {
    start.time <- Sys.time()
    n <- 50000
    x <- rep(1, n)
    output <- vector("integer", 0)
    for (i in seq_along(x)) {
        output <- c(output, lengths(x[[i]]))
    }
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    print(time.taken)
}

for (i in 1:5) {
    start.time <- Sys.time()
    n <- 50000
    x <- rep(1, n)
    output <- vector("integer", n)
    for (i in seq_along(x)) {
        output[[i]] <- lengths(x[[i]])
    }
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    print(time.taken)
}

# How does this affect performance? Design and execute an experiment. ANS: as
# expected, preallocation is hundreds of times faster.

### for loops variations ######################################################
# 1. Imagine you have a directory full of CSV files that you want to read in.
# You have their paths in a vector, 
#files <- dir("data/", pattern = "\\.csv$", full.names = TRUE)
# and now want to read each one with read_csv() . Write the for loop that will
# load them into a single data frame.
out <- vector("list", length(files))
for (i in seq_along(files)) {
    out[[i]] <- read_csv(i)
}
df <- bind_rows(out)

# 2. What happens if you use for (nm in names(x)) and x has no names? What if
# only some of the elements are named? What if the names are not unique?
# ANS, NULL; "a", "b", ""; "a", "a", ""
x <- c("a" = 1,"a" = 2, 3)
for (nm in names(x)) {
    print(nm)
}

# 3. Write a function that prints the mean of each numeric column in a data
# frame, along with its name. For example, show_mean(iris) would print:

print_col_means <- function(df) {
    for (i in seq_along(df)) {
        data <- df[[i]]
        if (is.numeric(data)) {
            name <- colnames(df)[[i]]
            col_mean <- mean(data, na.rm = T)
            formatted_col_mean <- format(round(col_mean, 2), nsmall = 2)
            print(glue("{name}:\t{formatted_col_mean}"))
        }
    }
}
print_col_means(iris)
print_col_means(mtcars)

#> show_mean(iris)
#> Sepal.Length: 5.84
#> Sepal.Width:  3.06
#> Petal.Length: 3.76
#> Petal.Width:  1.20

# (Extra challenge: what function did I use to make sure that the numbers lined
# up nicely, even though the variable names had different lengths?)

# 4. What does this code do? How does it work? ANS: named list, where names are
# two of the df colnames. The values are functions. The first converst cubic
# inches (in the displacement) into litres. The second turns the coluomn into a
# factor and renames the levels from 1 to 'manual' and from 2 to 'auto'. Since
# the function is named the same as a column the the function names can be used
# to index the column, and apply the desired function to transform that column,
# and inject it back into the original df, with the same name as before. Pretty
# sneaky.


trans <- list(
              disp = function(x) x * 0.0163871,
              am = function(x) {
                  factor(x, labels = c("auto", "manual"))
              }
)
for (var in names(trans)) {
    mtcars[[var]] <- trans[[var]](mtcars[[var]])
}

### for loops vs functionals ##################################################
# 1. Read the documentation for apply() . In the second case, what two for
# loops does it generalize?
X <- matrix(rnorm(6), nrow=3)
out <- vector("double", nrow(X))
for (row in seq_len(nrow(X))) {
    out[[row]] <- mean(X[row,])
}

out <- vector("double", ncol(X))
for (col in seq_len(ncol(X))) {
    out[[col]] <- mean(X[col,])
}

# 2. Adapt col_summary() so that it only applies to numeric columns. You might
# want to start with an is_numeric() function that returns a logical vector
# that has a TRUE corresponding to each numeric column.

col_summary <- function(df, fun) {
    numerics <- sapply(df, is.numeric)
    df <- df[numerics]
    out <- vector("double", length(df))
    for (i in seq_along(df)) {
        out[i] <- fun(df[[i]])
    }
    out
}
col_summary(iris, mean)

### the map functions #########################################################
# 1. Write code that uses one of the map functions to:

# a. Compute the mean of every column in mtcars .
map_dbl(mtcars, mean)

# b. Determine the type flights13::flights .
map_chr(flights, typeof)

# c. Compute the number of unique values in each column of iris .
map_int(iris, n_distinct)
map_int(iris, ~length(unique(.)))

# d. Generate 10 random normals for each of μ = –10, 0, 10, and 100.
map(c(-10, 0, 10, 100), ~rnorm(10, mean = .))

# 2. How can you create a single vector that for each column in a data frame
# indicates whether or not it’s a factor?
map_lgl(iris, is.factor)

# 3. What happens when you use the map functions on vectors that aren’t lists?
# What does map(1:5, runif) do? Why? ANS: no surprise

# 4. What does the following code do and why?
map(-2:2, rnorm, n = 5) # ANS: n = number of samples, so the . becomes the mean
# arg.
map_dbl(-2:2, rnorm, n = 5) # ANS: error because the output is a whole vector,
# each of which must be stored in a list, not as an element of a dbl vector

# 5. Rewrite map(x, function(df) lm(mpg ~ wt, data = df)) to eliminate the
# anonymous function.
map(x, function(df) lm(mpg ~ wt, data = df))
map(x, ~lm(mpg ~ wt, data = .))

### other patterns of loops ###################################################
# 1. Implement your own version of every() using a for loop. Compare it with
# purrr::every() . What does purrr’s version do that your version doesn’t? 
# ANS: returns NA if any of the values in x are NA

my_every <- function(x, f, ...) {
    for (i in x) {
        if (!f(i, ...)) {
            return (FALSE)
        }
        return (TRUE)
    }
}
x <- list(1:26, letters, list(1:26))
my_every(x, is_vector)
my_every(x, is_vector, n = 26)
my_every(x, is_vector, n = 10)
my_every(x, is_double)

# 2. Create an enhanced col_sum() that applies a summary function to every
# numeric column in a data frame.
col_sum <- function(df, fun, ...) {
    map(keep(df, is.numeric), fun, ...)
}
col_sum(iris, mean)

# 3. A possible base R equivalent of col_sum() is:

col_sum3 <- function(df, f) {
    is_num <- sapply(df, is.numeric)
    df_num <- df[, is_num]
    sapply(df_num, f)
}

# But it has a number of bugs as illustrated with the following inputs:

df <- tibble(
             x = 1:3,
             y = 3:1,
             z = c("a", "b", "c")
)

# OK
col_sum3(df, mean)
# Has problems: don't always return numeric vector
col_sum3(df[1:2], mean)
col_sum3(df[1], mean)
col_sum3(df[0], mean)

# What causes the bugs? ANS sapply tries to help, but is annoying and
# inconsistent
