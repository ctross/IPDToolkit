#' A helper function.
#'
#' @param 
#' x A vector to be mapped to the unit simplex.
#' @export

softmax <- function(x)
{
	 X = exp(x)
	 S = sum(X)
	 return(X/S)
}