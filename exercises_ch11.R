### introduction ##############################################################
# 1. In code that doesn’t use stringr, you’ll often see paste() and paste0() .
# What’s the difference between the two functions? What stringr function are
# they equivalent to? How do the func‐ tions differ in their handling of NA ?
# ANS: paste() is like str_c()
#      paste0() is like paste() but with separator = "" (more efficient)
#      paste() will turn an NA into "NA". Whereas str_c() will make a real NA
#      (like most other R functions).

# 2. In your own words, describe the difference between the sep and collapse
# arguments to str_c() . ANS str_c() sep arg is combines preceding string args
# into single string separated by <sep> whereas the collapse arg combines
# preceding **vector** of strings into single string separated by <collapse> .

# 3. Use str_length() and str_sub() to extract the middle character from a
# string. What will you do if the string has an even number of characters? ANS:
# for even numbers, I could just return "" (using a function).
a <- "123456"
str_sub(a, (str_length(a)/2)+1, (str_length(a)/2)+1)

# 4. What does str_wrap() do? When might you want to use it? ANS: formats
# paragraph to wrap at specified number of columns. Could be handy for help
# messages and the like.

# 5. What does str_trim() do? What’s the opposite of str_trim() ? ANS: remove
# leading/trailing whitespace. Opposte is str_pad().

# 6. Write a function that turns (e.g.) a vector c("a", "b", "c") into the
# string a, b, and c . Think carefully about what it should do if given a
# vector of length 0, 1, or 2.
myfunc <- function(str) {
    len <- length(str) 
    if (len == 0) {
        return ("")
    } else if (len == 1) {
        return (str)
    } else if (len == 2) {
        return (str_c(str, collapse = " and "))
    } else {
        return (str_c(
                      c(str_c(str[-len], collapse = ", "), str[len]),
                      collapse = ", and "))
    }
}
