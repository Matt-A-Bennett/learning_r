### creating factors ##########################################################
# 1. What happens if you parse a string that contains invalid dates?
# ymd(c("2010-10-10", "bananas")) ANS: coerced to NA, with warning

# 2. What does the tzone argument to today() do? Why is it important? ANS:
# controls the timezone used.

# 3. Use the appropriate lubridate function to parse each of the following
# dates:
d1 <- mdy("January 1, 2010")
d2 <- ymd("2015-Mar-07")
d3 <- dmy("06-Jun-2017")
d4 <- mdy(c("August 19 (2015)", "July 1 (2015)"))
d5 <- mdy("12/30/14") # Dec 30, 2014

