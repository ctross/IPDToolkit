//################################################################## Model Block
model{
//########################################################## Priors

// G ~ normal(10,1);
// H ~ normal(10,1);

for ( i in 1:N_individuals ) 
 to_vector(chi[i]) ~ normal(0,5);

 alpha ~ beta(1,1);
 
 pi ~ beta(1,1);
 psi ~ beta(1,1);
 xi ~ beta(1,15);

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
