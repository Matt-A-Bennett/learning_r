### introduction ##############################################################
# 1. What function would you use to read a file where fields are separated with
# "|"? ANS: read_delim(name, delim = '|')

# 2. Apart from file, skip, and comment, what other arguments do read_csv()
# and read_tsv() have in common? All of them: 
# "file",      "col_names",       "col_types",        "col_select",
# "id",        "locale",          "na",               "quoted_na",
# "quote",     "comment",         "trim_ws",          "skip",
# "n_max",     "guess_max",       "name_repair",      "num_threads",
# "progress",  "show_col_types",  "skip_empty_rows",  "lazy"

# 3. What are the most important arguments to read_fwf() ? ANS: file,
# col_positions

# 4. Sometimes strings in a CSV file contain commas. To prevent them from
# causing problems they need to be surrounded by a quoting character, like " or
# ' . By convention, read_csv() assumes that the quoting character will be " ,
# and if you want to change it you’ll need to use read_delim() instead. What
# arguments do you need to specify to read the following text into a data
# frame? "x,y\n1,'a,b'"
x <- "x,y\n1,'a,b'"
read_delim(x, ",", quote="'")

# 5. Identify what is wrong with each of the following inline CSV files. What
# happens when you run the code?
read_csv("a,b,x\n1,2,3\n4,5,6") # add x column
read_csv("a,b,x,y\n1,2\n1,2,3,4", na=c("")) # add x/y columns + missing value
read_csv("a,b\n\"1", na=c("")) # escaped double quote...?
read_csv("a,b\n1,2\na,b") # seems fine
read_delim("a;b\n1;3", ";") # specify delimiter

# 1. What are the most important arguments to locale()? ANS: data_names

# 2. What happens if you try and set decimal_mark and grouping_mark to the same
# character? What happens to the default value of grouping_mark when you set
# decimal_mark to “,”? What happens to the default value of decimal_mark when
# you set the grouping_mark to “.”?

# ANS: the grouping_mark and decimal_mark must be different
parse_number("1'000'000,87", locale=locale(grouping_mark = "'", decimal_mark=","))

# ANS: when the grouping_mark is a '.', the decimal_mark defaults to ',' (and
# vice versa)
parse_number("1.000.000,87", locale=locale(grouping_mark = '.'))

# 3. I didn’t discuss the date_format and time_format options to locale(). What
# do they do? Construct an example that shows when they might be useful.
# ANS: Automatic parsers: "%AD" parses with a flexible YMD parser, "%AT" parses
# with a flexible HMS parser.

# 4. If you live outside the US, create a new locale object that encapsulates
# the settings for the types of file you read most commonly.
uk_locale <- locale(date_format = "%d/%m/%y")
parse_date("02/07/05")
parse_date("02/07/05", locale = uk_locale)


# 5. What’s the difference between read_csv() and read_csv2()?
# ANS: ‘read_csv()’ and ‘read_tsv()’ are special cases of the more general
# ‘read_delim()’. They're useful for reading the most common types of flat file
# data, comma separated values and tab separated values, respectively.
# ‘read_csv2()’ uses ; for the field separator and , for the decimal point.
# This format is common in some European countries.

# 6. What are the most common encodings used in Europe? What are the most
# common encodings used in Asia? Do some googling to find out. ANS: leave me
# alone

# 7. Generate the correct format string to parse each of the following dates
# and times:
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
parse_time(t1, "%H%M")
parse_time(t2, "%H:%M:%OS %p")
