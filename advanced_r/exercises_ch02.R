### binding basics ############################################################
# 1. Explain the relationship between a, b, c and d in the following code:

a <- 1:10   # a binds to the values 1:10
b <- a      # b binds to a
c <- b      # c binds to b
d <- 1:10   # d binds to different values 1:10

# 2. The following code accesses the mean function in multiple ways. Do they
# all point to the same underlying function object? Verify this with
# lobstr::obj_addr(). ANS: yes.

unique(c(
lobstr::obj_addr(mean),
lobstr::obj_addr(base::mean),
lobstr::obj_addr(get("mean")),
lobstr::obj_addr(evalq(mean)),
lobstr::obj_addr(match.fun("mean"))
))

# 3. By default, base R data import functions, like read.csv(), will
# automatically convert non-syntactic names to syntactic ones. Why might this
# be problematic? What option allows you to suppress this behaviour? 
# ANS: check.names = FALSE

# 4. What rules does make.names() use to convert non-syntactic names into
# syntactic ones? # ANS: coerces to character, replaces illegal characters
# (given current locale) with periods, missing characters with a string "NA"
# Adds a period to keywords (like "if."). Can prepend "X" to make a legal
# start.

# 5. I slightly simplified the rules that govern syntactic names. Why is .123e1
# not a syntactic name? Read ?make.names for the full details. ANS: can start
# with a letter or a "...dot not followed by a number"

### copy-on-modify ############################################################

