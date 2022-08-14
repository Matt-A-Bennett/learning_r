### when should you write a function? #########################################
# 1. Why is TRUE not a parameter to rescale01() ? What would happen if x
# contained a single missing value, and na.rm was FALSE ? ANS: FALSE will make
# the range() function return NA for min and max, but only if finite is not
# TRUE (so in this case it has no effect).

# 2. In the second variant of rescale01() , infinite values are left unchanged.
# Rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1.

rescale01 <- function(x) {
    rng <- range(x, finite = TRUE)
    x <- (x - rng[1]) / (rng[2] - rng[1])
    x[x == Inf] <- 1
    x[x == -Inf] <- 0
    return(x)
}

x <- c(1:10, NA, Inf, -Inf)
rescale01(x)

# 3. Practice turning the following code snippets into functions. Think about
# what each function does. What would you call it? How many arguments does it
# need? Can you rewrite it to be more expressive or less duplicative?

prop_na <- function(x) {
    mean(is.na(x))
}

x <- c(1,2,NA,4,5,NA,7,8,9,10)
prop_na(x)

normalise_by_total <- function(x) {
    x / sum(x, na.rm = TRUE)
}
normalise_by_total(x)

coef_of_variation <- function(x) {
    sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
}
sd_over_mean(x)

# 4. Follow http://nicercode.github.io/intro/writing-functions.html to write
# your own functions to compute the variance and skew of a numeric vector.
x <- c(1:10, 10:5, NA)

drop_na <- function(x, na.rm = TRUE) {
    if (na.rm) {
        return(x[!is.na(x)])
    }
    return(x)
}

myvar <- function(x, na.rm = FALSE) {
    x <- drop_na(x, na.rm = na.rm)
    sq_diffs <- (x - mean(x)) ^ 2
    SS <- sum(sq_diffs)
    V <- SS/(length(x) - 1)
    return(V)
}

var(x, na.rm = T)
myvar(x, na.rm = T)

skew <- function(x, na.rm = FALSE) {
    x <- drop_na(x, na.rm = na.rm)
    sd <- sqrt(myvar(x, na.rm = na.rm))
    cubes <- ((x - mean(x)) / sd) ^ 3
    sum_cubes <- sum(cubes)
    n = length(x)
    return(sum_cubes /n)
}
skew(x, na.rm = T)

# 5. Write both_na() , a function that takes two vectors of the same length and
# returns the number of positions that have an NA in both vectors.

both_na <- function(v1, v2) {
    sum(is.na(v1) * is.na(v2))
}

v1 <- c(1, NA, 3, NA, NA)
v2 <- c(1, NA, 3, NA, 5)
both_na(v1, v2)

# 6. What do the following functions do? Why are they useful even though they
# are so short? ANS: the function name is more readable than the implementation
is_directory <- function(x) file.info(x)$isdir 
is_readable <- function(x) file.access(x, 4) == 0
# ANS file.access arg 4 queries read permission, and tests if the result is 0
# (success) or not

# 7. Read the complete lyrics to “Little Bunny Foo Foo.” There’s a lot of
# duplication in this song. Extend the initial piping example to re-create the
# complete song, and use functions to reduce the duplication. ANS: nah...

### functions are for humans and computers ####################################
# 1. Read the source code for each of the following three functions, puzzle out
# what they do, and then brainstorm better names:

f1 <- function(string, prefix) {
    substr(string, 1, nchar(prefix)) == prefix
}

f2 <- function(x) {
    if (length(x) <= 1) return(NULL)
    x[-length(x)]
}

f3 <- function(x, y) {
    rep(y, length.out = length(x))
}

# 2. Take a function that you’ve written recently and spend five minutes
# brainstorming a better name for it and its arguments.

# 3. Compare and contrast rnorm() and MASS::mvrnorm() . How could you make them
# more consistent?

# 4. Make a case for why norm_r() , norm_d() , etc., would be better than
# rnorm() , dnorm() . Make a case for the opposite.
