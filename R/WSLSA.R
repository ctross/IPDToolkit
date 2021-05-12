#' WSLSA function file.
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

WSLSA = function(i, coop, intent, coop_error, arb, arb_error, error_rate, arb_error_rate_type_1, arb_error_rate_type_2, standing, xi=0)
{
  if(i<3){
  # Coop without error on first move
  result = c(1, 1, 0, 0, 0, standing, standing)
  }else{
  callArb = ifelse(coop[i-1]==0, 1, 0)
  arbEr = ifelse(coop_error[i-1]==1, coin(1-arb_error_rate_type_1), coin(arb_error_rate_type_2))*callArb

  if(arbEr==1){ # if error is called, then do PAVLOV on basis of arb calls
   shift = ifelse(intent[i-2]==1,0,1)
   stay = intent[i-2]
  
   Y1 = ifelse((intent[i-2]+1)==2,1,0)          # If both cooperate, or
   Y2 = ifelse((1-intent[i-2])==1,1,0)          # if focal defected, but opponant cooperated
   do_coop = ifelse((Y1+Y2)>0, stay, shift)         # stay, if not, switch.  
  }

  else{ # if no error called, then just do normal PAVLOV
   shift = ifelse(intent[i-2]==1,0,1)
   stay = intent[i-2]
  
   Y1 = ifelse((intent[i-2]+coop[i-1])==2,1,0)      # If both cooperate, or
   Y2 = ifelse((coop[i-1]-intent[i-2])==1,1,0)      # if focal defected, but opponant cooperated
   do_coop = ifelse((Y1+Y2)>0, stay, shift)         # stay, if not, switch.  
   }
  do_coop = ifelse(do_coop==1, coin(1-xi), 0)
  er = ifelse(do_coop==0, 0, coin_V2(error_rate,i,coop_error))
  result = c(ifelse(er==1, 0, do_coop), do_coop, er, callArb, arbEr, standing, standing)
  }
  return(result)
}

