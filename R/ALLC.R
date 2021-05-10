#' ALLC function file
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

ALLC = function (i, coop, intent, coop_error, arb, arb_error, error_rate, 
    arb_error_rate_type_1, arb_error_rate_type_2, standing, xi=0) 
{
    if (i == 1) {
        result = c(1, 1, 0, 0, 0, standing, standing)
    }
    else {
        do_coop = 1
        er = ifelse(do_coop == 0, 0, coin_V2(error_rate, i, coop_error))
        result = c(ifelse(er == 1, 0, do_coop), do_coop, er, 
            0, 0, standing, standing)
    }
    return(result)
}