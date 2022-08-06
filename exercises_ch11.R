### introduction ##############################################################
# 1. In code that doesn’t use stringr, you’ll often see paste() and paste0() .
# What’s the difference between the two functions? What stringr function are
# they equivalent to? How do the func‐ tions differ in their handling of NA ?
# ANS: paste() is like str_c()
#      paste0() is like paste() but with separator = "" (more efficient)
#      paste() will turn an NA into "NA". Whereas str_c() will make a real NA
#      (like most other R functions).

# 2. In your own words, describe the difference between the sep and collapse
# arguments to str_c() . ANS str_c() sep arg is combines preceding string args
# into single string separated by <sep> whereas the collapse arg combines
# preceding **vector** of strings into single string separated by <collapse> .

# 3. Use str_length() and str_sub() to extract the middle character from a
# string. What will you do if the string has an even number of characters? ANS:
# for even numbers, I could just return "" (using a function).
a <- "123456"
str_sub(a, (str_length(a)/2)+1, (str_length(a)/2)+1)

# 4. What does str_wrap() do? When might you want to use it? ANS: formats
# paragraph to wrap at specified number of columns. Could be handy for help
# messages and the like.

# 5. What does str_trim() do? What’s the opposite of str_trim() ? ANS: remove
# leading/trailing whitespace. Opposte is str_pad().

# 6. Write a function that turns (e.g.) a vector c("a", "b", "c") into the
# string a, b, and c . Think carefully about what it should do if given a
# vector of length 0, 1, or 2.
myfunc <- function(str) {
    len <- length(str) 
    if (len == 0) {
        return ("")
    } else if (len == 1) {
        return (str)
    } else if (len == 2) {
        return (str_c(str, collapse = " and "))
    } else {
        return (str_c(
                      c(str_c(str[-len], collapse = ", "), str[len]),
                      collapse = ", and "))
    }
}
### basic regular expressions #################################################
# 1. Explain why each of these strings don’t match a \ : "\" , "\\" , "\\\" .
# ANS: "\"          escapes nothing
#      "\\"         enters just a backslash, which escapes nothing
#      "\\\" .      enters a backslash, which escapes nothing + escapes nothing

# 2. How would you match the sequence "'\ ? ANS: "\"'\\\\"

# 3. What patterns will the regular expression \..\..\.. match? How would you
# represent it as a string? ANS: .a.1.B

### anchors ###################################################################
# 1. How would you match the literal string "$^$" ? ANS: "\\$\\^\\$"

# 2. Given the corpus of common words in stringr::words , create regular
# expressions that find all words that:

# a. Start with “y”. ANS: "^y"

# b. End with “x”. ANS: "x$"

# c. Are exactly three letters long. (Don’t cheat by using str_length() !)
# ANS: "^...$"

# d. Have seven letters or more. Since this list is long, you might want to use
# the match argument to str_view() to show only the matching or non‐matching
# words. ANS: ".{7,}"

### character classes and alternatives ########################################

# 1. Create regular expressions to find all words that:

# a. Start with a vowel. ANS: "^[aeiou]"

# b. Only contain consonants. (Hint: think about matching “not”-vowels.)
# ANS: "[^aeiou]+"

# c. End with ed , but not with eed . ANS: "[^e]ed$"

# d. End with ing or ize . ANS: "(ing|ize)$"

# 2. Empirically verify the rule “i before e except after c.” ANS: ([^c]ie|cei)

# 3. Is “q” always followed by a “u”? ANS: "q[^u]"

# 4. Write a regular expression that matches a word if it’s probably written in
# British English, not American English. ANS: "ise"

# 5. Create a regular expression that will match telephone numbers as commonly
# written in your country. ANS: "\\d{5}\\s\\d{3}\s\\d{3}"

### repetition ################################################################
# 1. Describe the equivalents of ? , + , and * in {m,n} form.
# ANS: {0,1} {1,} {0,}

# 2. Describe in words what these regular expressions match (read carefully to
# see if I’m using a regular expression or a string that defines a regular
# expression):

# a. ^.*$                   ANS: any

# b. "\\{.+\\}"             ANS: {one or more chars in here}

# c. \d{4}-\d{2}-\d{2}      ANS: 4 digits, hyphen, 2 digits, hyphen, 2 digits

# d. "\\\\{4}"              ANS: \\\\ (yes, very funny)

# 3. Create regular expressions to find all words that:

# a. Start with three consonants.                      ANS: "^[^aeiou]{3}"

# b. Have three or more vowels in a row.               ANS: "[aeiou]{3}"

# c. Have two or more vowel-consonant pairs in a row.  ANS: "([aeiou][^aeiou]){2}"

### grouping and backreferences ###############################################

# 1. Describe, in words, what these expressions will match:

# a. (.)\1\1                ANS: aaa

# b. "(.)(.)\\2\\1"         ANS: abba

# c. (..)\1                 ANS: abab

# d. "(.).\\1.\\1"          ANS: abaca 

# e. "(.)(.)(.).*\\3\\2\\1" ANS: abcAnyThingHERE!!cba

# 2. Construct regular expressions to match words that:

# a. Start and end with the same character. ANS: "^(.).*\\1$"

# b. Contain a repeated pair of letters (e.g., “church” contains “ch” repeated
# twice). ANS: "(..)[a-z]*\\1"

# c. Contain one letter repeated in at least three places (e.g., “eleven”
# contains three “e”s). "(.)[a-z]*\\1[a-z]*\\1"

### detect matches ############################################################
