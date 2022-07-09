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
