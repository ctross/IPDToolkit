#' ATFT function file.
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
#'   \item Cell 1 - Did the player cooperate?
#'   \item Cell 2 - Did the player intend tocooperate?
#'   \item Cell 3 - Did the computer introduce an error?
#'   \item Cell 4 - Did the player call the arbitrator?
#'   \item Cell 5 - Did the arbitrator declare an error occured?
#'   \item Cell 6-7 - Returned standing.
#'   \item Cell 8-9 - Mid-round standing.
#' }
#' @export

ATFT = function(i , coop, intent, coop_error, arb, arb_error, error_rate, 
                arb_error_rate_type_1, arb_error_rate_type_2, standing, xi=0) 
{
  # If were are in round 1, half-round 1
  if (i==1){ 
  # Then cooperate without error on first move
  result = c(1, 1, 0, 0, 0, standing, standing)
  }
  # Otherwise   
  else{
  # Now use truth table to make move and update standings for the second time, when focal is giver
    if (i>2){ 
   updates = updater(tt,standing,1,intent[i-2],arb[i-1],arb_error[i-1])[1,]

   standing[1] = updates$new_focal_standing   # update standings
   standing[2] = updates$new_partner_standing #
    }

  standing_mid_round = standing 

  # Decide whether to call arbitrator
   # Call when: perceive defection and focal in good standing, or when perceive coop and focal in bad standing
   callArb_Soft =  ifelse(coop[i-1]==0 & standing[1]==1, 1, 0)
   callArb_Strict = 0 # ifelse(coop[i-1]==1 & standing[1]==0, 1, 0)
   callArb = ifelse(callArb_Soft + callArb_Strict == 0, 0, 1)
  
  # Arbitrator declares if error occured
  arbEr = ifelse(coop_error[i-1]==1, coin(1-arb_error_rate_type_1), coin(arb_error_rate_type_2))*callArb 
  # If error was inserted last round by computer, then coin(1-p_aerr1) give probability of arbitrator correctly classifying this
  # If error was not inserted last round by computer, then coin(p_aerr2) give probability of arbitrator misclassifying a real defection  

  # Now use truth table to make move and update standings for the first time, when focal is not giver
  updates = updater(tt,standing,0,coop[i-1],callArb,arbEr)[1,]

  do_coop = updates$move_choice                # pick move
  standing[1] = updates$new_focal_standing   # update standings
  standing[2] = updates$new_partner_standing #
 
 # Generate result vector
  do_coop = ifelse(do_coop==1, coin(1-xi), 0)
  er = ifelse(do_coop==0, 0, coin_V2(error_rate,i,coop_error)) # does computer introduce error?
  obs = ifelse(er==1, 0, do_coop)                         # return observated cooperation

  result = c(obs, do_coop, er, callArb, arbEr, standing, standing_mid_round) # store results
  }
  return(result)
}


