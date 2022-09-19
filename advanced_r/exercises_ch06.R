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
# 1. Explain the following results:

sum(1, 2, 3)  # does what it looks like
#> [1] 6
mean(1, 2, 3) # mean is computed for first arg, the rest are taken as extra args
#> [1] 1

sum(1, 2, 3, na.omit = TRUE)  # 'na.omit' is taken as a named value: T = 1
#> [1] 7
mean(1, 2, 3, na.omit = TRUE) # mean is computed for first arg, the rest are
                              # taken as extra args
#> [1] 1

# 2. Explain how to find the documentation for the named arguments in the
# following function call:

plot(1:10, col = "red", pch = 20, xlab = "x", col.lab = "blue")
#> ?graphics::plot  # to get all but last
#> ?par             # to get col.lab (refered from above)

# 3. Why does plot(1:10, col = "red") only colour the points, not the axes or
# labels? Read the source code of plot.default() to find out.
# ANS: looks like col arg (among others) are explicitly prevented from being
# passed as part of ... into axes and lable functions by makeing them come
# *after* the ... has been given to those functions:
# Axis <- function(..., col, bg, pch, cex, lty, lwd) Axis(...)

### exiting a function ########################################################
# 1. What does load() return? Why don’t you normally see these values?
# ANS: returns 'A character vector of the names of objects created, invisibly.'
# argument <verbose> is FALSE by default

# 2. What does write.table() return? What would be more useful?
# ANS: returns a call to a C function... return x - the object to be written
# would be more useful, as then it could be part of a pipe that writes an
# intermediate stop

# 3. How does the chdir parameter of source() compare to with_dir()? Why might
# you prefer one to the other?
# ANS:  for source, R cds to the file location, then evaluates it - could be
#           nice if that file sources other files using relative paths
#       for withr::with_dir, you can execute several statements in the dir

# 4. Write a function that opens a graphics device, runs the supplied code, and
# closes the graphics device (always, regardless of whether or not the plotting
# code works).

# 5. We can use on.exit() to implement a simple version of capture.output().

capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = TRUE, after = TRUE)

  sink(temp)
  on.exit(sink(), add = TRUE, after = TRUE)

  force(code)
  readLines(temp)
}
capture.output2(cat("a", "b", "c", sep = "\n"))
#> [1] "a" "b" "c"

# Compare capture.output() to capture.output2(). How do the functions differ?
# What features have I removed to make the key ideas easier to see? How have I
# rewritten the key ideas so they’re easier to understand?

# ANS: only code to be executed supplied, and output is written to a tempfile,
# (using sink), before being read back out into a character vector. 
#
# on.exit() lines are stored next to the lines which they clean up after, not
# spread apart throughout the function.

### function forms ############################################################
# 1. Rewrite the following code snippets into prefix form:

1 + 2 + 3
`+`(`+`(1, 2), 3)

1 + (2 + 3)
`+`(1, `+`(2, 3))

x = 1:6
n = 2
if (length(x) >= 5) x[[5]] else x[[n]]
`if`(length(x) >= 5, x[[5]], x[[n]])
`if`(`>=`(length(x), 5), x[[5]], x[[n]])
`if`(`>=`(length(x), 5), `[[`(x, 5), [[n]])
`if`(`>=`(length(x), 5), `[[`(x, 5), `[[`(x, n))

# 2. Clarify the following list of odd function calls:

x <- sample(c(1:10, NA), 20, replace = TRUE)
y <- runif(20, min = 0, max = 1)
cor(x, y, method = "kendall", use = "pairwise.complete.obs")

# 3. Explain why the following code fails:

`modify<-` <- function(x, position, value) {
  x[position] <- value
  x
}

x <- 1:3
modify(get("x"), 2) <- 10
#> Error: target of assignment expands to non-language object
get("x") <- `modify<-`(get("x"), 2, 10)
get("x") <- 10

# 4. Create a replacement function that modifies a random location in a vector.
`mod_rand<-` <- function(x, value) {
    ind <- sample(length(x), 1)
    x[ind] <- value
    return (x)
}

x = 1:3
mod_rand(x) <- 20
x

# 5. Write your own version of + that pastes its inputs together if they are
# character vectors but behaves as usual otherwise. In other words, make this
# code work:
`+` <- function(a, b) {
    if (is.character(a) && is.character(a)) {
    return (paste0(a, b))
    } else {
        return (base::`+`(a, b))
    }
}

1 + 2
#> [1] 3

"a" + "b"
#> [1] "ab"

# 6. Create a list of all the replacement functions found in the base package.
# Which ones are primitive functions? (Hint: use apropos().)

library(purrr)
out <- apropos('<-$', where = T, mode = 'function') %>%
    mget(envir = baseenv(), ifnotfound = NA) %>%
    keep(is.primitive) %>%
    names()
for (i in out) print(i)

# 7. What are valid names for user-created infix functions?

library(purrr)
out <- apropos('%.*%', where = T, mode = 'function') %>%
    mget(envir = baseenv(), ifnotfound = NA) %>%
    names()
print('already used in base:')
for (i in out) print(i)

# 8. Create an infix xor() operator.
`%xor%` <- function(a, b) {
    return (a != b)
}
    
for (i in c(1, 0)) {
    for (j in c(1, 0)) {
        print((i %xor% j) == (xor(i, j)))
    }
}

# 9. Create infix versions of the set functions intersect(), union(), and
# setdiff(). You might call them %n%, %u%, and %/% to match conventions from
# mathematics.
`%n%` <- function(x, y) {
    intersect(x, y)
}

`%u%` <- function(x, y) {
    union(x, y)
}

`%/%` <- function(x, y) {
    setdiff(x, y)
}
