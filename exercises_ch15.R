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

starts_with <- function(string, prefix) {
    substr(string, 1, nchar(prefix)) == prefix
}


remove_last <- function(x) {
    if (length(x) <= 1) return(NULL)
    x[-length(x)]
}

replicate <- function(x, y) {
    rep(y, length.out = length(x))
}

# 2. Take a function that you’ve written recently and spend five minutes
# brainstorming a better name for it and its arguments.

# 3. Compare and contrast rnorm() and MASS::mvrnorm() . How could you make them
# more consistent? ANS: mean %<%> mu and sd %<>% Sigma

# 4. Make a case for why norm_r() , norm_d() , etc., would be better than
# rnorm() , dnorm() . Make a case for the opposite. ANS: autocompletion, but I
# think I've seen functions like rnorm before... so maybe it's a 'thing'. Yep -
# there are other functions like rbinom... 

### conditional execution #####################################################
# 1. What’s the difference between if and ifelse() ? Carefully read the help
# and construct three examples that illustrate the key differences. ANS:
# they're very different... I'm not doing examples.

ifelse(c(1,2,3,4)>2, "yeap", "nope") 

# 2. Write a greeting function that says “good morning,” “good afternoon,” or
# “good evening,” depending on the time of day. (Hint: use a time argument that
# defaults to lubridate::now() . That

greet <- function(time = lubridate::now()) {
    hour = lubridate::hour(time)
    if (hour < 12)  {
        print("good morning")
    } else if (hour < 18) {
        print("good afternoon")
    } else {
        print("good evening")
    }
}

# 3. Implement a fizzbuzz function. It takes a single number as input. If the
# number is divisible by three, it returns “fizz”. If it’s divisible by five it
# returns “buzz”. If it’s divisible by three and five, it returns “fizzbuzz”.
# Otherwise, it returns the number. Make sure you first write working code
# before you create the function.

fizzbuzz <- function(x) {
    fizz = ""
    buzz = ""
    if (x %% 3 == 0) {
        fizz = "fizz"
    }
    if (x %% 5 == 0) {
        buzz = "buzz"
    }
    if (fizz == "" && buzz == "" ) {
        return(x)
    } else {
        print(paste0(fizz, buzz))
    }
}

# 4. How could you use cut() to simplify this set of nested if-else statements?

if (temp <= 0) {
    "freezing"
} else if (temp <= 10) {
    "cold"
} else if (temp <= 20) {
    "cool"
} else if (temp <= 30) {
    "warm"
} else {
    "hot"
}

temp = 30
cut(temp, breaks = c(  -Inf,       0,     10,      20,    30,  Inf),
          labels = c("freezing", "cold", "cool", "warm", "hot"),
          right = T)

# How would you change the call to cut() if I’d used < instead of <= ? What is
# the other chief advantage of cut() for this problem? (Hint: what happens if
# you have many values in temp ?) ANS: right = FALSE, and it performs on each
# element

# 5. What happens if you use switch() with numeric values? ANS: it's used to
# index the case to perform

# 6. What does this switch() call do? What happens if x is “e”? 
# ANS: once it matches, it runs down until it finds the first RHS (even
# non-matching) and evaluates it.
# ANS: nothing because not match and no default  (which I'll now add as "?", so
# it would be returned)

switch("e", "?",
       a = ,
       b = "ab",
       c = ,
       d = "cd"
)

# Experiment, then carefully read the documentation
