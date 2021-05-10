#' A helper function
#'
#' @param 
#' x A number to be mapped to the unit interval
#' @export

logistic <- function (x){
    p <- 1/(1 + exp(-x))
    p <- ifelse(x == Inf, 1, p)
    p
 }