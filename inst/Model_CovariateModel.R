//################################################################## Model Block
model{
//########################################################## Priors

// G ~ normal(10,1);
// H ~ normal(10,1);

 to_vector(beta) ~ normal(0,5);

for (i in 1:N_individuals){ 
 to_vector(chi[i]) ~ normal(0,50);
 }

 alpha_hat ~ normal(0,5);
 pi_hat ~ normal(0,5);
 psi_hat ~ normal(0,5);
 xi_hat ~ normal(0,5);

 nu_alpha ~ normal(0,5);                          
 nu_pi ~ normal(0,5);                       
 nu_psi ~ normal(0,5);                            
 nu_xi ~ normal(0,5);

//# Done accumulating terms, now add to target with proper mixture probabilities
  {
    for ( i in 1:N_individuals ) {
      target += log_sum_exp( Upsilon[i] + Theta[i] );
    }
  }
}
 
//################################################################## Generated quantities block 
generated quantities{
   vector[N_strategies] ThetaHat [N_individuals]; 
     
     {
     real denom;	
     for ( i in 1:N_individuals ) {
      denom	= log_sum_exp( Upsilon[i] + Theta[i] );
      ThetaHat[i] =  Upsilon[i] + Theta[i] - denom;
      }
   }
 }
