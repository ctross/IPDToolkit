#' Fit a finite mixture model using optimization
#'
#' @param 
#' d A data list of the format exported by simulate_round_robin().
#' @param 
#' covariates A matrix of covariates. Row number should equal the number of players. 
#' @param 
#' n_strategies The number of considered strategies. PrisonR considers 12 by default. Changing this requires advanced editing of the Stan code. Good luck!
#' @param 
#' eta_moves A term that controls the plausibility of implementation errors.
#' @param 
#' eta_arb A term that controls the plausibility of implementation errors.
#' @return A Stan object.
#' @export

fit_IPD_optim = function(d, covariates=NULL, n_strategies=12, eta_moves=4, eta_arb=4)
{
 
 for(i in 1:5) 
 d$moves <- rbind(rep(0,6), d$moves)
 head(d$moves,10)
 dat_list <- as.list(d$moves)

 dat_list$N_moves <- length(dat_list$g_round)
 dat_list$N_games <- max(dat_list$game_id)
 dat_list$N_individuals <- max(dat_list$actor_id)
 dat_list$N_strategies <- n_strategies

 if(!is.null(covariates)){
 dat_list$N_covariates <- ncol(covariates) 
 dat_list$Covariates <- covariates
 }

 tt[is.na(tt)] <- -1
 dat_list$tt <- tt
 dat_list$G <- rep(eta_moves, dat_list$N_individuals)
 dat_list$H <- rep(eta_arb, dat_list$N_individuals)

# Strategy by move
if(!is.null(covariates)){
 m_all1 <- stan_model(file = paste0(path,"/PrisonersDilema/StanCode/model_code_covariates.stan"))
 fit_optim <- optimizing(m_all1, data = dat_list, as_vector=FALSE, refresh=1)
 } else{
 m_all2 <- stan_model(file = paste0(path,"/PrisonersDilema/StanCode/model_code.stan"))
 fit_optim <- optimizing(m_all2, data = dat_list, as_vector=FALSE, refresh=1)	
 }

 return(fit_optim)
}
 


