cl <- function() {
    system('clear')
}

exit <- function() {
    q("no") 
}

mode <- function(x){
    u <- unique(x)
    tab <- tabulate(match(x, u))
    mean(u[tab==max(tab)])
}

str_showmatches <- function(str, pattern) {
    positions <- stringi::stri_locate_all_regex(str, pattern)
    match_display <- strrep(" ", nchar(str))
    overline <- strrep("_", nchar(str))
    n_matches <- length(positions[[1]])/2
    if (n_matches > 0) {
        for (i in seq(n_matches)) {
            start <- positions[[1]][i, ][1]
            stop  <- positions[[1]][i, ][2]
            # substitute match_display with overline at corrrect positions
            substr(match_display, start, stop) <- overline
        }
    }
    # put overline above the original string
    cat("pattern: ", pattern, "\n")
    cat("matches: ", match_display, "\n")
    cat("string : ", str, "\n")
}
