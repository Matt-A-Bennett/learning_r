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
