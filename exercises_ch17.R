### for loops #################################################################
# 1. Write for loops to:

# a. Compute the mean of every column in mtcars .
out <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
    out[[i]] <- mean(mtcars[[i]], na.rm = T)
}

# b. Determine the type flights13::flights . of each column in nyc
out <- vector("double", ncol(flights))
for (i in seq_along(flights)) {
    out[[i]] <- typeof(flights[[i]])
}

# c. Compute the number of unique values in each column of iris .
out <- vector("double", ncol(iris))
for (i in seq_along(iris)) {
    out[[i]] <- n_distinct(iris[[i]])
}

# d. Generate 10 random normals for each of μ = –10, 0, 10, and 100. Think
# about the output, sequence, and body before you start writing the loop.
mus <- c(-10, 0, 10, 100)
out <- vector("double", length(mus))
for (i in seq_along(mus)) {
    out[[i]] <- rnorm(1, i)
}

# 2. Eliminate the for loop in each of the following examples by taking
# advantage of an existing function that works with vectors:

# out <- ""
# for (x in letters) {
#     out <- stringr::str_c(out, x)
# }

str_c(letters, collapse = "")

x <- sample(100)
# sd <- 0
# for (i in seq_along(x)) {
#     sd <- sd + (x[i] - mean(x)) ^ 2
# }
# sd <- sqrt(sd / (length(x) - 1))

sd <- sqrt(var(x))


x <- runif(100)
# out <- vector("numeric", length(x))
# out[1] <- x[1]
# for (i in 2:length(x)) {
#     out[i] <- out[i - 1] + x[i]
# }
cumsum(x)


# 3. Combine your function writing and for loop skills:

pluralise <- function(word, n) {
    if (n != 1) {
        return (paste0(word, "s"))
    } else {
        return (paste0(word))
    }
}

# a. Write a for loop that prints() the lyrics to the children’s song “Alice
# the Camel.”
    n_humps <- c("no", "one", "two", "three", "four", "five")
for (i in length(n_humps):1) {
    for (j in 1:3) {
        print(glue("Alice the camel has {n_humps[[i]]} {pluralise('hump', i-1)}."))
    }
    print(glue("So go, Alice go!"))
    print(glue("Boom, boom, boom, boom!\n\n"))
}
print(glue("'Cause Alice is a horse of course!"))
print(glue("...how was that obvious?!"))

# b. Convert the nursery rhyme “Ten in the Bed” to a function. Generalize it to
# any number of people in any sleeping structure.
verse <- function(n_in_bed, sleeping_structure = "bed") {
    n <- c("one", "two", "three", "four", "five")
    stopifnot(n_in_bed <= length(n))
    for (i in n_in_bed:1) {
        if (i > 1) was_were = "were" else was_were = "was"
        print(glue('There {was_were} {n[[i]]} in the {sleeping_structure}'))
        print(glue('And the little one said,'))
        if (i == 1) {
            print(glue("Good night!"))
        } else {
            print(glue('"Roll over! Roll over!"'))
            print(glue('So they all rolled over'))
            print(glue('And one fell out'))
        }
        print(glue("\n"))
    }
}
verse(1, "hammock")

# c. Convert the song “99 Bottles of Beer on the Wall” to a function.
# Generalize to any number of any vessel containing any liquid on any surface.

n_surfaces_of_liquid_on_the_wall <- function(liquid = "beer", surface = "bottle", n = 99) {
    for (n in n_bottles:1) {
        print(glue("{n} {pluralise(surface, n)} of {liquid} on the wall, {n} {pluralise(surface, n)} of {liquid}."))
        print(glue("Take one down and pass it around, {n-1} {pluralise(surface, n-1)} of {liquid} on the wall."))
        print(glue("\n"))
    }
    print(glue("No more {surface}s of {liquid} on the wall, no more {surface}s of {liquid}."))
    print(glue("Go to the store and buy some more, 99 {surface}s of {liquid} on the wall."))
}
n_surfaces_of_liquid_on_the_wall(liquid = "water", surface = "cup", n = 2)

# 4. It’s common to see for loops that don’t preallocate the output and instead
# increase the length of a vector at each step:

for (i in 1:5) {
    start.time <- Sys.time()
    n <- 50000
    x <- rep(1, n)
    output <- vector("integer", 0)
    for (i in seq_along(x)) {
        output <- c(output, lengths(x[[i]]))
    }
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    print(time.taken)
}

for (i in 1:5) {
    start.time <- Sys.time()
    n <- 50000
    x <- rep(1, n)
    output <- vector("integer", n)
    for (i in seq_along(x)) {
        output[[i]] <- lengths(x[[i]])
    }
    end.time <- Sys.time()
    time.taken <- end.time - start.time
    print(time.taken)
}

# How does this affect performance? Design and execute an experiment. ANS: as
# expected, preallocation is hundreds of times faster.

