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
mod <- lm(y ~ x, data = sim1a)
coefs <- coef(mod)
ggplot(sim1a, aes(x, y)) +
    geom_point() +
    geom_abline(aes(intercept = coefs[1], slope = coefs[2]))

# 2. One way to make linear models more robust is to use a different distance
# measure. For example, instead of root-mean-squared distance, you could use
# mean-absolute distance:

make_prediction <- function(params, data) {
    return (pred <- params[1] + params[2]*data$x)
}

measure_distance <- function(mod, data) {
    diff <- data$y - make_prediction(mod, data)
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
