### environment basics ########################################################
library(rlang)

# 1. List three ways in which an environment differs from a list.
e1[1]               # can't index numerically
e1["a"] <- NULL     # doesn't remove object from e1
e1["self"] <- e1    # ponter can self reference

# 2. Create an environment as illustrated by this picture.
e1 <- env()
e1["loop"] <- e1

# 3. Create a pair of environments as illustrated by this picture.
e2 <- env()
e1["loop"] <- e2
e2["deloop"] <- e1

# 4. Explain why e[[1]] and e[c("a", "b")] don’t make sense when e is an
# environment.
# ANS: e is unordered. 

# 5. Create a version of env_poke() that will only bind new names, never
# re-bind old names. Some programming languages only do this, and are known as
# single assignment languages.
env_poke2 <- function(e, name, value) {
    if (!env_has(e, name)) {
        env_poke(e, name, value)
    } else {
        stop("nope")
    }
}

env_print(e1)
env_poke2(e1, "x", 3)

# 6. What does this function do? How does it differ from <<- and why might you
# prefer it? # Don't create it if you can't find it... that's confusing

rebind <- function(name, value, env = caller_env()) {
  if (identical(env, empty_env())) {
    stop("Can't find `", name, "`", call. = FALSE) # exit 1 got to the top
  } else if (env_has(env, name)) {
    env_poke(env, name, value) # exit 2, found it! modify it.
  } else {
    rebind(name, value, env_parent(env)) # recursively call itelf on parent
  }
}
rm("a")
a
rebind("a", 10)
#> Error: Can't find `a`
a <- 5
rebind("a", 10)
a
#> [1] 10

### recursing over environment ################################################
# 1. Modify where() to return all environments that contain a binding for name.
# Carefully think through what type of object the function will need to return.
where <- function(name, e = caller_env(), found_envs = list()) {
    if (identical(e, empty_env())) {
        return (found_envs)
    } else if (env_has(e, name)) {
        append(found_envs, e)
    } else {
        where(name, env_parent(e), found_envs)
    }
}

# 2. Write a function called fget() that finds only function objects. It should
# have two arguments, name and env, and should obey the regular scoping rules
# for functions: if there’s an object with a matching name that’s not a
# function, look in the parent. For an added challenge, also add an inherits
# argument which controls whether the function recurses up the parents or only
# looks in one environment.

fget <- function(name, e = caller_env(), inherits = TRUE) {
    if (identical(e, empty_env())) {
        stop("Not found")
    } else if (env_has(e, name) && is.function(env_get(e, name))) {
        return (env_get(e, name))
    } else {
        if (inherits) {
            fget(name, env_parent(e))
        } else {
            stop("Not found, and we're not searching the parents")
        }
    }
}

mean <- 10
fget("fget", inherits = F)

### special environments ######################################################
# 1. How is search_envs() different from env_parents(global_env())?
# ANS: a) includes global, b) includes only parents of global
# ANS: b) includes R_EmptyEnv

# 2. Draw a diagram that shows the enclosing environments of this function:

f1 <- function(x1) {
  f2 <- function(x2) {
    f3 <- function(x3) {
      x1 + x2 + x3
    }
f3(3)
}
  f2(2)
}
f1(1)

str(f1)

# 3. Write an enhanced version of str() that provides more information about
# functions. Show where the function was found and what environment it was
# defined in.

str2(x) {

}

### call stacks ###############################################################
