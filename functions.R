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
    positions <- str_locate_all(str, pattern)
    match_display <- strrep(" ", str_length(str))
    overline <- strrep("_", str_length(str))
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
