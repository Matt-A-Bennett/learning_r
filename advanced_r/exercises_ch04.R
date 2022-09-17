### selecting multiple elements ###############################################
# 1. Fix each of the following common data frame subsetting errors:

mtcars[mtcars$cyl == 4, ]
mtcars[-c(1:4), ]
mtcars[mtcars$cyl <= 5, ]
mtcars[mtcars$cyl == 4 | mtcars$cyl == 6, ]

# 2. Why does the following code yield five missing values? (Hint: why is it
# different from x[NA_real_]?)

x <- 1:5
x[NA] # logical NA is recycled to length of vector
#> [1] NA NA NA NA NA

# 3. What does upper.tri() return? How does subsetting a matrix with it work?
# Do we need any additional subsetting rules to describe its behaviour?
# ANS logical matrix were col index > row index. It's a 'vector' of T/F, and is
# used to subset like any other vector of T/F on a matrix

x <- outer(1:5, 1:5, FUN = "*")
x[upper.tri(x)]

# 4. Why does mtcars[1:20] return an error? How does it differ from the similar
# mtcars[1:20, ]? ANS the first is asking for columns 1:20 (too many!), the
# second is asking fof the rows 1:20, and all columns

# 5. Implement your own function that extracts the diagonal entries from a
# matrix (it should behave like diag(x) where x is a matrix).

diag2(x) {
    x <- outer(5:8, 1:7, FUN = "*")
    nrows <- nrow(x)
    ncols <- ncol(x)
    n_entries <- min(nrows, ncols)
    l_inds <- seq(1, nrows*n_entries, nrows+1)
    return (x[l_inds])
}

df <- data.frame(x = 1:3, y = letters[1:3], z = c(NA, NA, 1))
# 6. What does df[is.na(df)] <- 0 do? How does it work?
# ANS: str(is.na(df)) returns a logical matrix indicating missing values, which
# is used to subset the data frame, setting the values to zero

### selecting a single element ################################################
# 1. Brainstorm as many ways as possible to extract the third value from the
# cyl variable in the mtcars dataset. ANS: there are so many more too...
mtcars[3, 2]     # matrix subset
mtcars[2][3,]    # grab 2nd col as df with 1 col, and subset 3rd row
mtcars[[2]][3]   # grab 2nd col as vector, and subset 3rd element
mtcars[[2]][[3]] # same as above, using [[ ]] 
mtcars$cyl[3]    # same as above, using $ shorthand for first [[ ]] 
mtcars$cyl[[3]]  # same as above, using $ shorthand for first [[ ]] and  [[ ]]

# 2. Given a linear model, e.g., mod <- lm(mpg ~ wt, data = mtcars), extract
# the residual degrees of freedom. Then extract the R squared from the model
# summary (summary(mod))
str(mod)
mod$df.residual

mod_sum <- summary(mod)
str(mod_sum)

mod_sum$r.squared

### applications ##############################################################
# How would you randomly permute the columns of a data frame? (This is an
# important technique in random forests.) Can you simultaneously permute the
# rows and columns in one step?
df <- outer(1:5, 1:8)
df[sample(nrow(df)), sample(ncol(df))]

# How would you select a random sample of m rows from a data frame? What if the
# sample had to be contiguous (i.e., with an initial row, a final row, and
# every row in between)?

m = 3
df[sample(nrow(df), m), ]

s <- sample(nrow(df) - m + 1, 1)
df[s:(s + m - 1), ]

# How could you put the columns in a data frame in alphabetical order?
head(mtcars[, sort(colnames(mtcars))])
