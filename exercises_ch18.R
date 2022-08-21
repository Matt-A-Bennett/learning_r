### a simple model ############################################################
# 1. One downside of the linear model is that it is sensitive to unusual values
# because the distance incorporates a squared term. Fit a linear model to the
# following simulated data, and visualize the results. Rerun a few times to
# generate different simulated datasets. What do you notice about the model?
# ANS I think they want me to notice that it changes (since the noise is
# different each time)

sim1a <- tibble(
                x = rep(1:10, each = 3),
                y = x * 1.5 + 6 + rt(length(x), df = 2)
)
mod1 <- lm(y ~ x, data = sim1a)
coefs <- coef(mod1)
ggplot(sim1a, aes(x, y)) +
    geom_point() +
    geom_abline(aes(intercept = coefs[1], slope = coefs[2]))

# 2. One way to make linear models more robust is to use a different distance
# measure. For example, instead of root-mean-squared distance, you could use
# mean-absolute distance:

make_prediction <- function(params, data) {
    return (pred <- params[1] + params[2]*data$x)
}

measure_distance <- function(mod1, data) {
    diff <- data$y - make_prediction(mod1, data)
    mean(abs(diff))
}

# Use optim() to fit this model to the previous simulated data and compare it
# to the linear model.

abs_mod <- optim(c(0, 0), measure_distance, data = sim1a)

ggplot(sim1a, aes(x, y)) +
    geom_point() +
    geom_abline(aes(intercept = coefs[1], slope = coefs[2])) +
    geom_abline(aes(intercept = abs_mod$par[1], slope = abs_mod$par[2]),
                color = "red")

# 3. One challenge with performing numerical optimization is that it’s only
# guaranteed to find one local optima. What’s the problem with optimizing a
# three-parameter model like this? ANS: it's singular = a[1] + a[3] are
# dependent

model1 <- function(a, data) {
    a[1] + data$x * a[2] + a[3]
}

### visualising models ########################################################
# 1. Instead of using lm() to fit a straight line, you can use loess() to fit a
# smooth curve. Repeat the process of model fitting, grid generation,
# predictions, and visualization on sim1 using loess() instead of lm() . How
# does the result compare to geom_smooth() ? ANS: I bet it's the same (friston
# face)

lmod <- loess(y ~ x, data = sim1a)

grid <- data_grid(sim1a, x)

grid <- grid %>% 
    gather_predictions(mod1, lmod,)

ggplot(sim1a, aes(x)) +
    geom_point(aes(y = y)) +
    geom_line(aes(y = pred, color = model), data = grid) +
    geom_smooth(aes(y = y), color = "blue", se = F)


# 2. add_predictions() is paired with gather_predictions() and
# spread_predictions() . How do these three functions differ?
# ANS: spread_predictions() adds predictions *to* multiple models,
# gather_predictions() adds predictions *from* multiple models (see code above)

# 3. What does geom_ref_line() do? What package does it come from? Why is
# displaying a reference line in plots showing residuals useful and important?
# ANS: adds a horizontal OR a vertical line. It's important because you want to
# assess if the points are evenly distributed about the zero point (no skewed)

# 4. Why might you want to look at a frequency polygon of absolute residuals?
# What are the pros and cons compared to looking at the raw residuals? ANS: You
# want to see if they're normally distributed. frequency polygons summarise the
# data (which is good) but could obscure individual points (which is bad)

### formulas and model families ###############################################
# 1. What happens if you repeat the analysis of sim2 using a model without an
# intercept? What happens to the model equation? What happens to the
# predictions? ANS: no difference because the intercept in a categorical model
# is the grand mean of the data and is estimated implicitly

# 2. Use model_matrix() to explore the equations generated for the models I fit
# to sim3 and sim4 . Why is * a good shorthand for interaction? ANS: because
# the columns representing the interaction terms are litterally formed by
# multiplying the 'main effect' columns

# 3. Using the basic principles, convert the formulas in the following two
# models into functions. (Hint: start by converting the categorical variable
# into 0-1 variables.) 
mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

model_matrix(sim3, y ~ x1 * x2)


additive_mod_matrix <- function(data) {
    code <- keep(data, map_lgl(data, is.factor))
    levels <- unique(code)
    dm <- matrix(nrow = nrow(data), ncol = nrow(levels)-1+2)
    dm[,1] <- rep(1, nrow(data))
    dm[,2] <- data$x1
    for (i in seq_along(levels[[1]][2:4]) ) {
        dm[,i+2] <- as.numeric(levels[[1]][i] == code[[1]])
    }        
    dm <- as_tibble(dm)
    dm <- setNames(dm, c("(Intercept)", "x1", "x2b", "x2c", "x2d"))
    return (dm)
}

interactive_mod_matrix <- function(data) {
    dm <- additive_mod_matrix(data)
    dm$`x1:x2b` <- dm$x1 * dm$x2b
    dm$`x1:x2c` <- dm$x1 * dm$x2c
    dm$`x1:x2d` <- dm$x1 * dm$x2d
    return (dm)
}

additive_mod_matrix(sim3)
interactive_mod_matrix(sim3)

# 4. For sim4 , which of mod1 and mod2 is better? I think mod2 does a slightly
# better job at removing patterns, but it’s pretty subtle. Can you come up with
# a plot to support my claim?

mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

resid <- gather_residuals(sim4, mod1, mod2)

ggplot(resid, aes(abs(resid), color = model)) +
    geom_freqpoly(binwidth = 0.5)
