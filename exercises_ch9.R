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
# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical?
# Carefully consider the following example:
stocks <- tibble(
                 year = c(2015, 2015, 2016, 2016),
                 half = c( 1, 2, 1, 2),
                 return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
    pivot_wider(names_from = year, values_from = return) %>% 
    pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")
# (Hint: look at the variable types and think about column names.)
# ANS: taking the columns names to values doesn't know to make them numbers...

# pivot_longer() has a names_ptypes argument, e.g.  names_ptypes = list(year =
# double()). What does it do? ANS: throw error if the type is not as expected
stocks %>% 
    pivot_wider(names_from = year, values_from = return) %>% 
    pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return",
                 names_ptypes = list(year = double()))

# ANS: we can transform them on the fly with *_transform()
stocks %>% 
    pivot_wider(names_from = year, values_from = return) %>% 
    pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return",
                 names_transform = list(year = as.integer))

# 2. Why does this code fail? ANS need to backtick c(`1999`, `2000`)
table4a %>% 
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")

# 3. What would happen if you widen this table? Why? How could you add a new
# column to uniquely identify each value? ANS: Error because Phillip Woods is
# in there twice (age 45 and 50...)
people <- tribble(
                  ~name,               ~key,      ~value,
                  #------------------|----------|-------
                  "Phillip  Woods",    "age",     45,
                  "Phillip  Woods",    "height",  186,
                  "Phillip  Woods",    "age",     50,
                  "Jessica  Cordero",  "age",     37,
                  "Jessica  Cordero",  "height",  156
)

people %>% 
    group_by(name, key) %>%
    mutate(obs = row_number()) %>%
    pivot_wider(names_from = key, values_from = value)

# 4. Tidy the simple tibble below. Do you need to make it wider or longer? What
# are the variables?
preg <- tribble(
                ~pregnant,  ~male,  ~female,
                "yes",      NA,     10,
                "no",       20,     12
)

pivot_longer(preg, -pregnant, names_to = "sex", values_to = "count",
             values_drop_na = TRUE) %>%
mutate(female = (sex == 'female'),
       pregnant = (pregnant == 'yes')) %>%
select(female, pregnant, count)

### separating and uniting ####################################################
# 1. What do the extra and fill arguments do in separate()? Experiment with the
# various options for the following two toy datasets.

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
    separate(x, c("one", "two", "three"),
             sep = ',', extra = 'merge',
             remove = F)

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
    separate(x, c("one", "two", "three"),
            sep = ',', fill = 'right',
            remove = F)

# 2. Both unite() and separate() have a remove argument. What does it do? Why
# would you set it to FALSE? ANS: appends new columns to existing df (good for
# seeing if things went well, and maybe you just don't want to drop the orig)

# 3. Compare and contrast separate() and extract(). Why are there three
# variations of separation (by position, by separator, and with groups), but
# only one unite? ANS: unite() always puts things back together in the order
# it's told end-to-end, so less precision needed than when separating
