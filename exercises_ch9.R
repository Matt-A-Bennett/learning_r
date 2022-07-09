### tidy data #################################################################
# 1. Using prose, describe how the variables and observations are organized in
# each of the sample tables.
# table1: tidy! 1 observation per row, 1 variable per column, 1 value per cell
# table2: variables 'cases' and 'population' appear as levels of type.. untidy!
# table3: variable rate is computed from cases/pop (but the computation is not
#         actually done... it's just a <chr> of two values, so not quite tidy)
# table4a: columns are not variables, they are values of the variable 'year'
# table4b: same as above

# 2. Compute the rate for table2 , and table4a + table4b . You will need to
# perform four operations: a. Extract the number of TB cases per country per
# year. b. Extract the matching population per country per year. c. Divide
# cases by population, and multiply by 10,000. d. Store back in the appropriate
# place. Which representation is easiest to work with? Which is hardest? Why?
table1 %>%
    mutate(rate = cases/population*10000)

# christ alive...
cases <- table2$count[table2$type == 'cases']
population <- table2$count[table2$type == 'population']
rate = cases / population * 10000

tmp <- table2 %>%
    filter(type == 'population') %>%
    mutate(count = rate, type = 'rate') 

table2_rate <- bind_rows(table2, tmp) %>%
    arrange(country, year, type, count)

# regexps solve all things
table3 %>%
    mutate(cases = parse_number(rate),
           population = parse_number(str_extract(rate, '(?<=/).*')),
           rate = cases/population * 10000)

# one liner!
table4c <- bind_cols(table4b[1], table4a[-1] / table4b[-1] * 10000) 

# 3. Re-create the plot showing change in cases over time using table2 instead
# of table1 . What do you need to do first?
table2 %>%
    pivot_wider(names_from = type, values_from = count) %>%
    ggplot(aes(year, cases, group = country)) +
    geom_line() +
    geom_point(aes(color = country))

### pivoting ##################################################################
# 1. Why are gather() and spread() not perfectly symmetrical? Carefully
# consider the following example:

stocks <- tibble(
                 year = c(2015, 2015, 2016, 2016),
                 half = c( 1, 2, 1, 2),
                 return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>%
    spread(year, return) %>%
    gather("year", "return", `2015`:`2016`)

# (Hint: look at the variable types and think about column names.) Both
# spread() and gather() have a convert argument. What does it do?

# 2. Why does this code fail?

table4a %>%
    gather(1999, 2000, key = "year", value = "cases")
#> Error in eval(expr, envir, enclos):
#> Position must be between 0 and n

# 3. Why does spreading this tibble fail? How could you add a new column to fix
# the problem?

people <- tribble(
                  ~name,            ~key,    ~value,
                  #-----------------|--------|------
                  "Phillip Woods", "age", 45,
                  "Phillip Woods", "height", 186,
                  "Phillip Woods", "age", 50,
                  "Jessica Cordero", "age", 37,
                  "Jessica Cordero", "height", 156
)

# 4. Tidy this simple tibble. Do you need to spread or gather it? What are the
# variables?

preg <- tribble(
                ~pregnant, ~male, ~female,
                "yes", NA, 10,
                "no", 20, 12
)
