### choices ###################################################################
# 1. What type of vector does each of the following calls to ifelse() return?

str(ifelse(list(TRUE, 2), 1, "no"))
str(ifelse(FALSE, 1, "no"))
str(ifelse(NA, 1, "no"))

# Read the documentation and write down the rules in your own words.
# ANS: Same attributes as the test vector, Mode will be coreced from logical if
# needed (can't be a characeter, since a char is not interpretable as a
# logical)

# 2. Why does the following code work?

x <- 1:10
if (length(x)) "not empty" else "empty" # if length zero, interpret as FALSE
#> [1] "not empty"

x <- numeric()
if (length(x)) "not empty" else "empty" # if length zero, interpret as FALSE
#> [1] "empty"

### loops #####################################################################
# 1. Why does this code succeed without errors or warnings?

x <- numeric()
out <- vector("list", length(x))
for (i in 1:length(x)) {
  out[i] <- x[i] ^ 2 # single [0] returns the an empty list 
  # out[i] <- x[[i]] ^ 2 # [[0]] tries to get the zeroth element
}
out

# 2. When the following code is evaluated, what can you say about the vector
# being iterated? ANS: it doesn't re-evaluate the xs on each iteration

xs <- c(1, 2, 3)
for (x in xs) {
  xs <- c(xs, x * 2)
}
xs
#> [1] 1 2 3 2 4 6

# 3. What does the following code tell you about when the index is updated?
# ANS i updated at the beggining of each iteration
for (i in 1:3) {
  i <- i * 2
  print(i) 
}
#> [1] 2
#> [1] 4
#> [1] 6
