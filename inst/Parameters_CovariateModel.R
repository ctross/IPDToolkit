//###################################################### Parameters to Estimate
parameters{
 vector[N_individuals] alpha_hat;                                
 vector[N_individuals] pi_hat;                  
 vector[N_individuals] psi_hat;                 
 vector[N_individuals] xi_hat;               

 vector[N_covariates+1] nu_alpha;                          
 vector[N_covariates+1] nu_pi;                           
 vector[N_covariates+1] nu_psi;                             
 vector[N_covariates+1] nu_xi;                                                            

 vector[N_strategies-1] chi [N_individuals];                
 matrix[N_covariates, N_strategies-1] beta;                 
}

//########################################### Transformed Parameters to Estimate
transformed parameters{
 vector<lower=0,upper=1>[N_individuals] alpha;               //# Prob of calling arb after a defection
 vector<lower=0,upper=1>[N_individuals] pi;                  //# RANDY cooperation rate
 vector<lower=0,upper=1>[N_individuals] psi;                 //# Generosity rate
 vector<lower=0,upper=1>[N_individuals] xi;                  //# Sneaky rate

 vector[N_strategies] Theta [N_individuals]; // #Individual mixture rates
 vector[N_strategies] Upsilon [N_individuals]; //# One log prob term for each candidate strategy
{
	matrix[N_individuals, N_strategies-1] x_beta = Covariates * beta;

    for(j in 1:N_individuals){
      Theta[j]=log_softmax(append_row(0, chi[j] + to_vector(x_beta[j]))); 

      alpha[j] = inv_logit(alpha_hat[j] + append_col(1,Covariates[j])*nu_alpha);
      pi[j] = inv_logit(pi_hat[j] + append_col(1,Covariates[j])*nu_pi);
      psi[j] = inv_logit(psi_hat[j] + append_col(1,Covariates[j])*nu_psi);
      xi[j] = inv_logit(xi_hat[j] + append_col(1,Covariates[j])*nu_xi);
      }
}

//########################################################## Strategies
//# init mixture terms for accumulation
  for ( i in 1:N_individuals ) Upsilon[i] = rep_vector(0,N_strategies);

 {
 vector[2] p;  //# Temp for calculations
 int game_start;

  for ( i in 1:N_moves ) {
//# First moves in table should be zero filler before first game
    if ( g_round[i] > 0 ) {

      if ( g_round[i]==1 ) {
        game_start = i; //# ATFT needs this to pass history from start of game
      }
    
//# ALLD
 p = Pred_ALLD(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i]);
 p = P(p, arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],1] +=  sum( p );

//# ALLC
 p = Pred_ALLC(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i]);
 p = P(p,arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],2] += + sum( p );
 
//# RANDY
 p = Pred_RANDY(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i],  pi[actor_id[i]]);
 p = P(p,arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],3] += sum( p );

//# TFT
 p = Pred_SneakyTFT(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],4] += sum( p );

//# TF2T 
 p = Pred_SneakyTF2T(g_round[i], arb[(i-3):i], arb_err[(i-3):i], coop[(i-3):i], coop_intent[(i-3):i], coop_err[(i-3):i], xi[actor_id[i]]);
 p = P(p, arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],5] += sum( p );
 
//# GTFT
 p = Pred_SneakyGTFT(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i], psi[actor_id[i]], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],6] += sum( p );
 
//# Pavlov
 p = Pred_SneakyWSLS(g_round[i], arb[(i-2):i], arb_err[(i-2):i], coop[(i-2):i], coop_intent[(i-2):i], coop_err[(i-2):i], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],7] += sum( p );
 
//# UTFT
 p = Pred_SneakyTFTA(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],8] += sum( p );

//# UTF2T 
 p = Pred_SneakyTF2TA(g_round[i], arb[(i-3):i], arb_err[(i-3):i], coop[(i-3):i], coop_intent[(i-3):i], coop_err[(i-3):i], xi[actor_id[i]]);
 p = P(p, arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],9] += sum( p );
 
//# UGTFT
 p = Pred_SneakyGTFTA(g_round[i], arb[(i-1):i], arb_err[(i-1):i], coop[(i-1):i], coop_intent[(i-1):i], coop_err[(i-1):i], psi[actor_id[i]], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],10] += sum( p );
 
//# UPavlov
 p = Pred_SneakyWSLSA(g_round[i], arb[(i-2):i], arb_err[(i-2):i], coop[(i-2):i], coop_intent[(i-2):i], coop_err[(i-2):i], xi[actor_id[i]]);
 p = P(p,arb[i],coop_intent[i],G[actor_id[i]],H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],11] += sum( p );

//# ATFT 
 p = Pred_SneakyATFT(g_round[i], arb[game_start:i], arb_err[game_start:i], coop[game_start:i], coop_intent[game_start:i], coop_err[game_start:i],tt, xi[actor_id[i]]);
 p = P(p, arb[i], coop_intent[i], G[actor_id[i]], H[actor_id[i]], alpha[actor_id[i]]);
 Upsilon[actor_id[i],12] += sum( p );

 }}
}
 
}

