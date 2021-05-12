#' ALLD function file.
#'
#' @param 
#' i The round ID code.
#' @param 
#' coop Was cooperation observed?
#' @param 
#' intent The the player intend to cooperate?
#' @param 
#' coop_error Was an error introduced by the computer?
#' @param 
#' arb Was the arbitrator called?
#' @param 
#' arb_error Did the arbitrator declare an error?
#' @param 
#' error_rate The rate at which the computer introduces errors of the form C to D.
#' @param 
#' arb_error_rate_type_1 The arbitrators rate of failing to detect a real error.
#' @param 
#' arb_error_rate_type_2 The arbitrators rate of claiming an error was a true defection.
#' @param 
#' standing A vector of standing.
#' @param 
#' xi The sneaky rate of the strategy.
#' @return A vector of information.
#' \itemize{
#'   \item Cell 1 - Did the player cooperate.
#'   \item Cell 2 - Did the player intend tocooperate.
#'   \item Cell 3 - Did the computer introduce an error?
#'   \item Cell 4 - Did the player call the arbitrator?
#'   \item Cell 5 - Did the arbitrator declare an error occured?
#'   \item Cell 6-7 - Returned standing.
#'   \item Cell 8-9 - Mid-round standing.
#' }
#' @export

ALLD = function(i, coop, intent, coop_error, arb, arb_error, error_rate, 
                 arb_error_rate_type_1, arb_error_rate_type_2, standing, xi=0) 
{
    result = c(0, 0, 0, 0, 0, standing, standing)
    return(result)
}
