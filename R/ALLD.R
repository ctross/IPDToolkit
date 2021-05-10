#' ALLD function file
#'
#' @param 
#' i The round ID code
#' @param 
#' standing A vector of standing.
#' @return A vector of information.
#' \itemize{
#'   \item Cell 1 - Did the player cooperate
#'   \item Cell 2 - Did the player intend tocooperate
#'   \item Cell 3 - Did the computer introduce an error?
#'   \item Cell 4 - Did the player call the arbitrator?
#'   \item Cell 5 - Did the arbitrator declare an error occured?
#'   \item Cell 6-7 - Returned standing.
#'   \item Cell 8-9 - Mid-round standing.
#' }
#' @export

ALLD = function (i, coop, intent, coop_error, arb, arb_error, error_rate, 
    arb_error_rate_type_1, arb_error_rate_type_2, standing,xi=0) 
      {
    result = c(0, 0, 0, 0, 0, standing, standing)
    return(result)
      }
