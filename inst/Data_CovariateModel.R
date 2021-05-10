//################################################################### Model Data
//# Version of model that uses longtable data format
data{
 int N_moves;             //# Length of moves table (all games)
 int N_games;             //# Length of games table (num games)
 int N_individuals;       //# Number of unique individuals
 int N_strategies;        //# Number of candiate strategies
 int N_covariates;        //# Number of covariates

//# Move table
 int game_id[N_moves];    //# ID of game
 int actor_id[N_moves];   //# ID of acting player
 int g_round[N_moves];    //# Round in game
 int arb[N_moves];        //# Called arbitrator in response to previous move
 int arb_err[N_moves];    //# Arbitrator error
 int coop[N_moves];       //# Player observed to have cooperated on move
 int coop_err[N_moves];   //# Coop error
 int coop_intent[N_moves];//# Player intended to coop

//# Player table 
//# Row is player id as in other tables
 matrix[N_individuals, N_covariates] Covariates;   //# Matrix of covariates
 vector[N_individuals] G;                          //# Individual implementation error rates moves
 vector[N_individuals] H;                          //# Individual implementation error rates arbitrator calls

//# Truth table
 int tt [80, 13];
}
