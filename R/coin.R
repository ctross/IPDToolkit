#' A helper function to flip a random coin.
#'
#' @param 
#' p The probability of a head.
#' @export

coin = function(p)
{
  x = rbinom(1, size=1, p)
  return(x)
}
