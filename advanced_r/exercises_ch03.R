### atomic vectors ############################################################
# 1. How do you create raw and complex scalars? (See ?raw and ?complex.)
as.raw()
complex(real = 2,imaginary = 3) == 2+3i

# 2. Test your knowledge of the vector coercion rules by predicting the output
# of the following uses of c():

c(1, FALSE) # 1, 0
c("a", 1)   # "a", "1"
c(TRUE, 1L) # 1, 1 

# 3. Why is 1 == "1" true? Why is -1 < FALSE true? Why is "one" < 2 false?
# ANS: "1" == "1", -1 < 0; "one" < "2" in 'alphabetical/collation order' but locales
# can mess you up with this easily...

# 4. Why is the default missing value, NA, a logical vector? What’s special
# about logical vectors? (Hint: think about c(FALSE, NA_character_).)
# ANS: logical won't corece other types to logical, so if NA_character_ was the
# default, it would coerce other types to it...

# 5. Precisely what do is.atomic(), is.numeric(), and is.vector() test for?
# ANS: atomic or NULL
#    :
#    : is vector of mode, and has no attributes other than names...

