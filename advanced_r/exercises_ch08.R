### signalling conditions #####################################################
library(rlang)

# 1. Write a wrapper around file.remove() that throws an error if the file to
# be deleted does not exist.

file.remove2 <- function(f) {
    if (!file.exists(f)) {
        stop("file does not exist")
    }
    file.remove(f)
}

# 2. What does the appendLF argument to message() do? How is it related to
# cat()?

# ANS:
# from message():
# appendLF: logical: should messages given as a character string
#                    have a newline appended?

# to do this with `cat()`, you'd need to provide the `"\n"` as a string, or as
# a `sep` argument 


### handling conditions #######################################################
# 1. What extra information does the condition generated by abort() contain
# compared to the condition generated by stop() i.e. what’s the difference
# between these two objects? Read the help for ?abort to learn more.

str(catch_cnd(stop("An error")))
str(catch_cnd(abort("An error"))) # you can supply any extra meta data. 
                                  # by default, the whole traceback is given

# 2. Predict the results of evaluating the following code

show_condition <- function(code) {
  tryCatch(
    error = function(cnd) "error",
    warning = function(cnd) "warning",
    message = function(cnd) "message",
    {
      code
      NULL
    }
  )
}

show_condition(stop("!"))
# "error"
show_condition(10)
# NULL
show_condition(warning("?!"))
# "warning"
show_condition({
  10
  message("?")
  warning("?!")
})
# "message"

# 3. Explain the results of running this code: ANS: too difficult...

withCallingHandlers(
  message = function(cnd) message("b"),
  withCallingHandlers(
    message = function(cnd) message("a"),
    message("c")
  )
)
#> b
#> a
#> b
#> c

# 4. Read the source code for catch_cnd() and explain how it works.
# ANS: wrapper around tryCatch. If the code throws a specific condition, the
# class of the condition is returned.

# 5. How could you rewrite show_condition() to use a single handler?
show_condition2 <- function(code) {
    tryCatch(
             attributes(
                        catch_cnd(code)
                        )[["class"]][2])
}

show_condition2(stop("!"))
# "error"
show_condition2(10)
# NULL
show_condition2(warning("?!"))
# "warning"
show_condition2({
  10
  message("?")
  warning("?!")
})
# "message"


### custom conditions #########################################################
# 1. Inside a package, it’s occasionally useful to check that a package is
# installed before using it. Write a function that checks if a package is
# installed (with requireNamespace("pkg", quietly = FALSE)) and if not, throws
# a custom condition that includes the package name in the metadata.

check_if_installed <- function(package) {
    if (!requireNamespace(package, quietly = FALSE)) {
        rlang::abort(
                     "package_not_installed",
                     message = paste0("package ", package, " is not installed"),
                     package = package
        )
    }
    return (TRUE)
}

a <- check_if_installed("worm")

# 2. Inside a package you often need to stop with an error when something is
# not right. Other packages that depend on your package might be tempted to
# check these errors in their unit tests. How could you help these packages to
# avoid relying on the error message which is part of the user interface rather
# than the API and might change without notice?

# ANS: use abort to return an custom error type

### applications ##############################################################

# 1. Create suppressConditions() that works like suppressMessages() and
# suppressWarnings() but suppresses everything. Think carefully about how you
# should handle errors.

suppressConditions <- function(expr) {
    withCallingHandlers(
                        warning = function(cnd) {
                            rlang::cnd_muffle(cnd)
                        },
                        message = function(cnd) {
                            rlang::cnd_muffle(cnd)
                        },
                        tryCatch(
                                 error = function(cnd) {
                                 },
                                 expr
                        )
    )
}

suppressed <- suppressConditions(supress_me())

supress_me <- function() {
    message("message")
    warning("warning")
    stop("error")
    return ("Made it!")
}

# 2. Compare the following two implementations of message2error(). What is the
# main advantage of withCallingHandlers() in this scenario? (Hint: look
# carefully at the traceback.)

message2error <- function(code) {
    withCallingHandlers(code, message = function(e) stop(e))
}
message2error2 <- function(code) {
    tryCatch(code, message = function(e) stop(e))
}

message2error2(stop())
traceback()

# 3. How would you modify the catch_cnds() definition if you wanted to recreate
# the original intermingling of warnings and messages? ANS: Q out of date...

# 4. Why is catching interrupts dangerous? Run this code to find out. ANS:
# can't break out of loop

bottles_of_beer <- function(i = 99) {
    message(
            "There are ", i, " bottles of beer on the wall, ", 
            i, " bottles of beer."
    )
    while(i > 0) {
        tryCatch(
                 Sys.sleep(1),
                 interrupt = function(err) {
                     i <<- i - 1
                     if (i > 0) {
                         message(
                                 "Take one down, pass it around, ", i, 
                                 " bottle", if (i > 1) "s", " of beer on the wall."
                         )
                     }
                 }
        )
    }
    message(
            "No more bottles of beer on the wall, ", 
            "no more bottles of beer."
    )
}
