#' Simulate a gameplay sequence between 2 strategies.
#'
#' @param 
#' n_rounds The number of complete rounds to play.
#' @param 
#' strategies A 2-vector of strategies to compete. Names must match legal function files: i.e., "ALLC", "TFT", "GTFT", "TFTA", etc.
#' @param 
#' error_rate The rate at which the computer introduces errors of the form C to D.
#' @param 
#' arb_error_rate_type_1 The arbitrators rate of failing to detect a real error.
#' @param 
#' arb_error_rate_type_2 The arbitrators rate of claiming an error was a true defection.
#' @return A list of information.
#' \itemize{
#'   \item g_round - The game round ID code.
#'   \item actor_id - Player ID codes.
#'   \item arb - Was the arbitrator called to start the round?
#'   \item arb_err - Did the arbitrator declare an error occured?
#'   \item coop - Did an observed cooperation occur?
#'   \item coop_intent - Was cooperation intended?
#'   \item coop_err - Was an error in cooperation introduced by the computer.
#'   \item stand_1_Focal - End-round standing of focal.
#'   \item stand_1_Alter - End-round standing of alter.
#'   \item stand_mr_Focal - Mid-round standing of focal.
#'   \item stand_mr_Alter - Mid-round standing of alter.
#' }
#' @export

simulate_sequence = function(n_rounds=40, strategies=c("ATFT","ATFT"), error_rate=0.05, arb_error_rate_type_1=0.1, arb_error_rate_type_2=0.1, xi=c(0,0), pID=c(1,2))
{
     
############################################################################### 
# Model game sequences
# Init storage
 n = n_rounds
 m = 2*n # Number of rounds
 coop = rep(NA, m)
 intent = rep(NA, m)
 coop_error = rep(0, m)
 arb = rep(NA, m)
 arb_error = rep(NA, m)  
 
 stand_1_Focal = rep(NA, m)
 stand_1_Alter = rep(NA, m)   

 stand_mr_Focal = rep(NA, m)
 stand_mr_Alter = rep(NA, m)   

 player = 2
 standing_1 = matrix(1, nrow=2, ncol=2) # Both start in good standing from both perspectives
 
 for (i in 1:m){
 # Players take turns across rounds
 player = ifelse( player==1 , 2 , 1 )
 partner = 2 - player + 1

 # Call strat for this player
 move = do.call( strategies[player] , list( i , coop, intent, coop_error, arb, arb_error, error_rate, arb_error_rate_type_1, arb_error_rate_type_2, standing_1[player,], xi[player] ) )
 coop[i] = move[1]
 intent[i] = move[2]
 coop_error[i] = move[3]
 arb[i] = move[4]
 arb_error[i] = move[5]

 standing_1[player,] = move[6:7] 

 stand_1_Focal[i] = move[6]
 stand_1_Alter[i] = move[7]  

 stand_mr_Focal[i] = move[8]
 stand_mr_Alter[i] = move[9]  
 }

 result = list(
  g_round=1:m,
  actor_id=rep( pID , length.out=m ),
  arb=arb,
  arb_err=arb_error,
  coop=coop,
  coop_intent=intent,
  coop_err=coop_error,
  stand_1_Focal=stand_1_Focal,
  stand_1_Alter=stand_1_Alter,
  stand_mr_Focal=stand_mr_Focal,
  stand_mr_Alter=stand_mr_Alter
  )

 return(result)
} 
 
