#' Simulate a gameplay sequence between 2 strategies
#'
#' @param 
#' players A vector of strategies to compete pairwise in a round-robin. Names must match legal function files: i.e., "ALLC", "TFT", "GTFT", "TFTA" etc.
#' @param 
#' n_rounds The number of complete rounds to play
#' @param 
#' n_games The number of games constructed from random pairing of players when 'mode' is 'random'.
#' @param 
#' matchups A n_games by 2 matrix, used when 'mode' is 'specified', with numeric values indicating which players are paired in each game.
#' @param 
#' error_rate The rate at which the computer introduces errors of the form C to D.
#' @param 
#' arb_error_rate_type_1 The arbitrators rate of failing to detect a real error.
#' @param 
#' arb_error_rate_type_2 The arbitrators rate of claiming an error was a true defection.
#' @param 
#' mode 'mode' must be: 'pairwise', 'random', or 'specified'. 'pairwise' creates a true round robin, with each player playing each other player. 'random' creates n_games of random pairings. 'specified' lets the user pass in the exact pairings of players using the 'matchups' matrix.
#' @return A list of information.
#' \itemize{
#'   \item moves - A move data table
#'   \item games - A game data table
#'   \item players - A players data table
#' }
#' @export

 simulate_round_robin = function(players=c("ATFT", "TFT", "TFTA" ), n_rounds=40, n_games=NULL, matchups=NULL, xi=0,
                                 error_rate=0.05, arb_error_rate_type_1=0.1, arb_error_rate_type_2=0.1, mode="pairwise" ){

  if(mode=="pairwise"){
  # Make pairs
  n_players = length(players)
  total_games = choose(n_players,2)
  games = t(combn(n_players, 2))
   }

  if(mode=="random"){
  # Make pairs
  if(is.null(n_games)) stop(" 'n_games' must be provided when 'mode' is 'random'. ")
  n_players = length(players)
  total_games = n_games
  games = matrix(NA,nrow=total_games,ncol=2)

  for(i in 1:total_games)  
   games[i,] = sample(n_players, 2)    
  }

  if(mode=="specified"){
  # Make pairs
  if(is.null(matchups)) stop(" 'matchups' must be provided when 'mode' is 'specified'. 'matchups' is a n_games by 2 matrix, with numeric values indicating which players are paired in each game. ")
  n_players = length(players)
  total_games = nrow(matchups)
  games = matchups
   }

  if(! mode %in% c("pairwise", "random", "specified" )) stop(" 'mode' must be: 'pairwise', 'random', or 'specified'. ")
  
  if(length(xi)==1){
   xi = rep(xi, n_players)
   }

  sims = lapply( 1:nrow(games), function(i) {
  strats = c(players[games[i,]] )
  a_game = simulate_sequence(n=n_rounds, strat=strats,  pID=games[i,], error_rate=error_rate, arb_error_rate_type_1=arb_error_rate_type_1, arb_error_rate_type_2=arb_error_rate_type_2, xi=xi[games[i,]]) 
  a_game$game_id = i
  return(a_game)
  })
  
  moves = as.data.frame(sims[[1]])
  for(i in 2:length(sims)) 
  moves = rbind(moves, as.data.frame(sims[[i]]))
  result = list(moves=moves, games=games, players=players)
  return(result)
  }
 
