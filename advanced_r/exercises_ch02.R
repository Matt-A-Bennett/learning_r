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

# 1. Why is tracemem(1:10) not useful?
tracemem(1:10) # the values don't have a name and so you don't get to trace
               # changes to that object

# 2. Explain why tracemem() shows two copies when you run this code. Hint:
# carefully look at the difference between this code and the code shown earlier
# in the section.

x <- c(1L, 2L, 3L)
tracemem(x)

x[[3]] <- 4 # this is not an integer, thus we need to change to double which
            # takes more space therefore we are modifying the whole vector
            # (adding an integer/char to a vector of doubles doesn't need more)

# 3. Sketch out the relationship between the following objects:

a <- 1:10               # a points to vector object
b <- list(a, a)         # b points to list, each element points to same vector
c <- list(b, a, 1:10)   # c points to list, 1st el points to same list as b,
                        # 2nd el points to that same vector again, 3rd el
                        # points to new vector

# 4. What happens when you run this code? ANS: in '<- x', the 'x' is the
# original object (pointing to the vector), so the 2nd el of the list points to
# this original pointer (which itself points to the vector)

x <- list(1:10)
x[[2]] <- x

Draw a picture.

      (1:10)
       ^  ^
x > [  | ] |
           |
       ----,
      |
x > [ | ; |] <--
          |    |
          -----

### object size ###############################################################
# 1. In the following example, why are object.size(y) and obj_size(y) so
# radically different? Consult the documentation of object.size().

y <- rep(list(runif(1e4)), 100) # 100 pointers to the same object

object.size(y) # overestimtes by ~100 because doesn't take into account sharing
#> 8005648 bytes
obj_size(y)    # accurate - does take into account sharing
#> 80,896 B

# 2. Take the following list. Why is its size somewhat misleading?

funs <- list(mean, sd, var)
obj_size(funs)
#> 17,608 B

obj_size(mean)  #  1.13 kB
obj_size(sd)    #  4.48 kB
obj_size(var)   # 12.47 kB

# 3. Predict the output of the following code:

a <- runif(1e6)
obj_size(a) # 8 bytes per val * 1e6 = 8'000'000 B + 48 B for list

b <- list(a, a)
obj_size(b)      # 8 MB + 48 B + 2 * 8 B = 8'000'112 B
obj_size(a, b)   # 8 MB + 48 B + 3 * 8 B = 8'000'120 B (a is shared, 2
                 # pointers, one to a list with two pointers)

str(b)
b[[1]][[1]] <- 10 # change the 1st vector el of the 1st list el
obj_size(b)       # 16 MB
obj_size(a, b)    # 16 MB ('a' still exists, so only need to point)

b[[2]][[1]] <- 10 # change the 1st vector el of the 2nd list el
obj_size(b)       # 16 MB (we have 2 distinct vectors)
obj_size(a, b)    # 16 MB + 8 MB ('a' distinct from the 2 pointed to by 'b')

