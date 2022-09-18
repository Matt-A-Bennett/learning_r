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

### lazy evaluation ###########################################################

# 1. What important property of && makes x_ok() work? ANS: it's a logical AND

x_ok <- function(x) {
  !is.null(x) && length(x) == 1 && x > 0
}

x_ok(NULL)
#> [1] FALSE
x_ok(1)
#> [1] TRUE
x_ok(1:3)
#> [1] FALSE

# What is different with this code? Why is this behaviour undesirable here?
# ANS: this one keeps evaluating even if a condition is FALSE

x_ok <- function(x) {
  !is.null(x) & length(x) == 1 & x > 0 
}

x_ok(NULL)
#> logical(0)
x_ok(1)
#> [1] TRUE
x_ok(1:3)
#> [1] FALSE FALSE FALSE

# 2. What does this function return? Why? Which principle does it illustrate?
# ANS: 100 because z <- 100 is evaluated first, then x = z, the x is returned

f2 <- function(x = z) {
  z <- 100
  x
}
f2()

# 3. What does this function return? Why? Which principle does it illustrate?
# ANS 2 1 because y <- 1, and x gets the return value of { ; 2}
# the default y = 0 is not used since y already got set

y <- 10
f1 <- function(x = {y <- 1; 2}, y = 0) {
  c(x, y)
}
f1()
y

# 4. In hist(), the default value of xlim is range(breaks), the default value
# for breaks is "Sturges", and

range("Sturges")
#> [1] "Sturges" "Sturges"

# Explain how hist() works to get a correct xlim value. ANS: Sturges is a
# function which figures out break points from a data vector x (other functions
# can be explicitly used instead of this default one)

# 5. Explain why this function works. Why is it confusing?

show_time <- function(x = stop("Error!")) { # if x not supplied, default waiing
  stop <- function(...) Sys.time() # redefine stop as the return value of fct
                                   # (... args passed in aren't used)
  print(x) # lazy eval x = stop, which is now returne val time
}
show_time() # without supplying x, the above takes place
#> [1] "2021-02-21 19:22:36 UTC"

# 6. How many arguments are required when calling library()? ANS: none

### ... (dot-dot-dot) #########################################################
