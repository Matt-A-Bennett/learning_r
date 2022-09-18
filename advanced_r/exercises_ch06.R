### choices ###################################################################
# 1. Given a name, like "mean", match.fun() lets you find a function. Given a
# function, can you find its name? Why doesn’t that make sense in R?
# ANS a function's name can be anything e.g. mean2 <- mean (you could even have
# multiple references to the same function!)

# 2. It’s possible (although typically not useful) to call an anonymous
# function. Which of the two approaches below is correct? Why?

function(x) 3()     # this one is merely defining two separate functions
#> function(x) 3()
(function(x) 3)()   # this one is defining and calling one function
#> [1] 3

# 3. A good rule of thumb is that an anonymous function should fit on one line
# and shouldn’t need to use {}. Review your code. Where could you have used an
# anonymous function instead of a named function? Where should you have used a
# named function instead of an anonymous function?

# 4. What function allows you to tell if an object is a function? What function
# allows you to tell if a function is a primitive function?
?is.function
?is.primitive

# 5. This code makes a list of all functions in the base package.

objs <- mget(ls("package:base", all = TRUE), inherits = TRUE)
funs <- Filter(is.function, objs)
str(funs)

# Use it to answer the following questions:
library(purrr)

    # a. Which base function has the most arguments?
    n_args <- funs %>%
        map(formals) %>%
        map_int(length)

    n_args %>%
        sort(decreasing = T) %>%
        head(n=1)

    # b. How many base functions have no arguments? What’s special about those
    # functions?
    prim <- funs %>%
        map(is.primitive) %>%
        unlist()

    names(n_args[!prim & n_args == 0]) %>%
        length()

    # c. How could you adapt the code to find all primitive functions?
    funs %>%
        keep(is.primitive) %>%
        names()

# 6. What are the three important components of a function?
# ANS: formals, body, environment

# 7. When does printing a function not show the environment it was created in?
# ANS: When it's a primitive function

### lexical scoping ###########################################################
# 1. What does the following code return? Why? Describe how each of the three
# c’s is interpreted.

c <- 10 # standard
c(c = c) # equivalent to c(a = c), but with name as c. First c here is the
         # function, args come from 'c' = the c <- 10

# 2. What are the four principles that govern how R looks for values?
# masking, func vs var, fresh start, happens when the func is run

# 3. What does the following function return? Make a prediction before running
# the code yourself.

f <- function(x) {
  f <- function(x) {
    f <- function() {
      x ^ 2
    }
    f() + 1
  }
  f(x) * 2
}
f(10)

((10^2) + 1) * 2
