#' WACKO function file
#'
#' @param 
#' i The round ID code
#' @param 
#' coop A vector of observed cooperation data
#' @param 
#' intent A vector of observed cooperation intent data
#' @param 
#' coop_error A vector of data indicating when the computer introduce errors
#' @param 
#' arb A vector of observed calls for arbitration 
#' @param 
#' arb_error A of arbitration outcomes
#' @param 
#' error_rate The rate at which the computer introduces errors of the form C to D.
#' @param 
#' arb_error_rate_type_1 The arbitrators rate of failing to detect a real error.
#' @param 
#' arb_error_rate_type_2 The arbitrators rate of claiming an error was a true defection.
#' @param 
#' standing A 2-vector of standings.
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

 WACKO = function(i, coop, intent, coop_error, arb, arb_error, error_rate, 
                   arb_error_rate_type_1, arb_error_rate_type_2, standing){
  if(i==1){# Cooperate without error on first move.
   result = c(1, 1, 0, 0, 0, standing, standing)
   }
  else{# Behave opposite of TFT. Cooperating with defectors. Defect on cooperators.                
   do_coop = ifelse(coop[i-1]==1,0,1) 
   er = ifelse(do_coop==0, 0, coin_V2(error_rate,i,coop_error))
   result = c(ifelse(er==1, 0, do_coop), do_coop, er, 0, 0, standing, standing)
   }
  return(result)
  }


