### choices ###################################################################
# 1. Given a name, like "mean", match.fun() lets you find a function. Given a
# function, can you find its name? Why doesn’t that make sense in R?

# 2. It’s possible (although typically not useful) to call an anonymous
# function. Which of the two approaches below is correct? Why?

function(x) 3()
#> function(x) 3()
(function(x) 3)()
#> [1] 3

# 3. A good rule of thumb is that an anonymous function should fit on one line
# and shouldn’t need to use {}. Review your code. Where could you have used an
# anonymous function instead of a named function? Where should you have used a
# named function instead of an anonymous function?

# 4. What function allows you to tell if an object is a function? What function
# allows you to tell if a function is a primitive function?

# 5. This code makes a list of all functions in the base package.

objs <- mget(ls("package:base", all = TRUE), inherits = TRUE)
funs <- Filter(is.function, objs)

# Use it to answer the following questions:

    # a. Which base function has the most arguments?

    # b. How many base functions have no arguments? What’s special about those
    # functions?

    # c. How could you adapt the code to find all primitive functions?

# 6. What are the three important components of a function?

# 7. When does printing a function not show the environment it was created in?
