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

