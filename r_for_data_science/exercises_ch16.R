### important types of atomic vectors #########################################
# 1. Describe the difference between is.finite(x) and !is.infinite(x) .
# ANS: NA is not considered finite, but IS considered to be non-infinite. But
# this seems sensible non-surprising behaviour... although the ! might be
# expected to negate the output of is.finite()... so that's maybe surprising.

is.finite(c(1, NA, NaN, Inf, -Inf)) 
!is.infinite(c(1, NA, NaN, Inf, -Inf)) 

# 2. Read the source code for dplyr::near() (Hint: to see the source code, drop
# the () ). How does it work? ANS: simply.

# 3. A logical vector can take three possible values. How many possible values
# can an integer vector take? How many possible values can a double take? Use
# Google to do some research. ANS: 2^31 - 1 = 2147483647 and 2^53

# 4. Brainstorm at least four functions that allow you to convert a double to
# an integer. How do they differ? Be precise. ANS: all the rounding methods you
# can dream up.
round(c(-2.5, -1.5, -0.5, 0.5, 1.5, 2.5, 3.5, 4.5, 5.5, 6.5, 7.5, 8.5))

# 5. What functions from the readr package allow you to turn a string into a
# logical, integer, and double vector? ANS: parse_*()

### using atomic vectors ######################################################
# 1. What does mean(is.na(x)) tell you about a vector x ? What
# about sum(!is.finite(x)) ? ANS: proportion of NAs in x and number of
# non-finite values in x

# 2. Carefully read the documentation of is.vector() . What does it
# actually test for? ANS: a vector without attributes (except names)
# Why does is.atomic() not agree with the definition of atomic vectors above?
# ANS: is.atomic() considers NULL to be a vector

# 3. Compare and contrast setNames() with purrr::set_names() .

# 4. Create functions that take a vector as input and return:
x <- c(1, 2, NA, Inf, 3, NaN, -1)
# a. The last value. Should you use [ or [[ ?

last_val <- function(x) {
    stopifnot(is_vector(x))
    return (x[[length(x)]])
}
last_val(x)

# b. The elements at even numbered positions.
even_values <- function(x) {
    stopifnot(is_vector(x))
    evens <- x[x %% 2 == 0]
    return (evens)
}

even_values(x)

# c. Every element except the last value.
drop_last <- function(x) {
    stopifnot(is_vector(x))
    return (x[-length(x)])
}

drop_last(x)

# d. Only even numbers (and no missing values).
even_values_drop_na <- function(x) {
    evens <- even_values(x)
    evens_drop_na <- evens[!is.na(evens)]
    return (evens_drop_na)
}

even_pos_drop_na(x)


# 5. Why is x[-which(x > 0)] not the same as x[x <= 0] ?
# ANS: subsetting with indices vs subsetting with logical. The latter method
# coerces NaN to NA

# 6. What happens when you subset with a positive integer that’s bigger than
# the length of the vector? What happens when you subset with a name that
# doesn't exist? ANS: NA is returned
x <- c("a" = 1, "b" = 2)
x[3]
x["c"]

### recursive vectors (lists) #################################################
# 1. Draw the following lists as nested sets:

# a. list(a, b, list(c, d), list(e, f))

# b. list(list(list(list(list(list(a))))))

# 2. What happens if you subset a tibble as if you’re subsetting a list? What
# are the key differences between a list and a tibble? ANS: they are the same,
# except tibbles require the same length of every column

df <- tribble(~a, ~b, ~c,
               1,  2,  3,
               4,  5,  6
)

df_list <- list(a = list(1,4), b = list(2, 5), c = list(3, 6))

str(df)
str(df_list)

df[[1]][1]
df_list[[1]][1]

### augmented vectors #########################################################
# 1. What does hms::hms(3600) return? How does it print? What primitive type is
# the augmented vector built on top of? What attributes does it use?
x <- hms::hms(3600)
x
typeof(x)
attributes(x)

# 2. Try and make a tibble that has columns with different lengths. What
# happens? ANS: error with tribble(), recycle length 1 vector in tibble(),
# error with more than length 1.
df <- tribble(~a, ~b, ~c,
               1,  2,  3,
               4,  5
)

df <- tibble(a = c(1,4), b = c(2, 5), c = 3)
df <- tibble(a = c(1,4), b = c(2, 5), c = c(3, 3, 3))

# 3. Based of the previous definition, is it OK to have a list as a column of a
# tibble? ANS: yes
df <- tribble(~a, ~b, ~c,
               list(1),  list(2, 2),  list(3, "b", NA),
)
