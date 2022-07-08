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
