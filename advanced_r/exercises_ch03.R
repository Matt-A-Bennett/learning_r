### atomic vectors ############################################################
# 1. How do you create raw and complex scalars? (See ?raw and ?complex.)
as.raw()
complex(real = 2,imaginary = 3) == 2+3i

# 2. Test your knowledge of the vector coercion rules by predicting the output
# of the following uses of c():

c(1, FALSE) # 1, 0
c("a", 1)   # "a", "1"
c(TRUE, 1L) # 1, 1 

# 3. Why is 1 == "1" true? Why is -1 < FALSE true? Why is "one" < 2 false? ANS:
# "1" == "1", -1 < 0; "one" < "2" in 'alphabetical/collation order' but locales
# can mess you up with this easily...

# 4. Why is the default missing value, NA, a logical vector? What’s special
# about logical vectors? (Hint: think about c(FALSE, NA_character_).)
# ANS: logical won't corece other types to logical, so if NA_character_ was the
# default, it would coerce other types to it...

# 5. Precisely what do is.atomic(), is.numeric(), and is.vector() test for?
# ANS: atomic or NULL
#    :
#    : is vector of mode, and has no attributes other than names...

### attributes ################################################################
# 1. How is setNames() implemented? How is unname() implemented? Read the
# source code. ANS: very simply and directly - basically a wrapper around
# names()

# 2. What does dim() return when applied to a 1-dimensional vector? When might
# you use NROW() or NCOL()? ANS: NULL, and to preallocate for something

# 3. How would you describe the following three objects? What makes them
# different from 1:5? ANS: they're like vectors lying along one cartesian axis
# in 3D space. 1:5 doesn't have dimensions.

x1 <- array(1:5, c(1, 1, 5))
x2 <- array(1:5, c(1, 5, 1))
x3 <- array(1:5, c(5, 1, 1))

# 4. An early draft used this code to illustrate structure():

structure(1:5, comment = "my attribute")
#> [1] 1 2 3 4 5

structure(1:5, i_am_not_a_comment = "my attribute")
#> [1] 1 2 3 4 5
#> attr(,"i_am_not_a_comment")
#> [1] "my attribute"

# But when you print that object you don’t see the comment attribute. Why?
# Is the attribute missing, or is there something else special about it? (Hint:
# try using help.)
