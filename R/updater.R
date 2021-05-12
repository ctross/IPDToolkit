#' A helper function for ATFT.
#'
#' @param 
#' tt The truth table for ATFT.
#' @param 
#' standing The standing vector of focal and alter.
#' @param 
#' f_is_g Is focal giver in this half round? 
#' @param 
#' coop Was move cooperate or defect?
#' @param 
#' callArb Was arbitrator called?
#' @param 
#' arbEr Did arbitrator declare that an error occured?
#' @export

updater = function(tt, standing, f_is_g, coop, callArb, arbEr)
{
  if(f_is_g==0){
     updates = tt[which(tt$initial_focal_standing==standing[1] &     # find rows with my standing now 
                      tt$initial_partner_standing==standing[2] &     # find rows with my belief of partners standing now
                      tt$focal_is_giver==f_is_g &                    # find rows where focal is giver is correct
                      tt$partners_observed_move==coop &              # find rows with observed move from partner last round
                      tt$focal_calls_arb==callArb &                  # find rows with correct arb call
                      tt$error_called==arbEr),]                      # find rows with correct arb response
                     }
    else{
     updates = tt[which(tt$initial_focal_standing==standing[1] &     # find rows with my standing now 
                      tt$initial_partner_standing==standing[2] &     # find rows with my belief of partners standing now
                      tt$focal_is_giver==f_is_g &                    # find rows where focal is giver is correct
                      tt$move_intent==coop &                         # find rows with observed move from partner last round
                      tt$focal_calls_arb==callArb &                  # find rows with correct arb call
                      tt$error_called==arbEr),]                      # find rows with correct arb response
    }

                      return(updates)
}
