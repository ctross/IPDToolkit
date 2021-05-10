//############################################################# Custom functions

//####################################### Checks if Arbitrator should be called
real Pred_Arb_simple(int the_round, int[] arb, int[] arb_error, int[] coop, int[] coop_err){
 real pred_arb;
  if(the_round==1){
     pred_arb=0;
      }else{
      pred_arb=(coop[1]==0)?1:0;
      }
return pred_arb;
}

//######################################################### Probability function
//# Takes predictions for arb and coop(Pred) and outputs log-prob of joint
//# observed note that Pred elements need not be 0 1 but can be probabilities
//# This requires log_mix to prevent underflow issues
//#
//# G is individual coop error parameter
//# H is individual arb error parameter
vector P(vector Pred, int arb, int coop_intent, real G, real H, real PArb){
 vector[2] log_prob;
 vector[2] LER;
 real X;
 
 X = (Pred[1]==1)?PArb:0;
 //#X=Pred[1];

//# Log prob of observed arb call
  LER[1]=log(1/(1+exp(-H)));
  LER[2]=log(1/(1+exp( H)));
  if(arb==1){
   log_prob[1]=log_mix(X,LER[1],LER[2]);
   }else{
   log_prob[1]=log_mix(X,LER[2],LER[1]);
   }

//# Log prob of observed coop move
  LER[1]=log(1/(1+exp(-G)));
  LER[2]=log(1/(1+exp( G)));
//# X=(Pred*(1/(1+exp(-1/G)))+(1-Pred)*(1/(1+exp(1/G))))^Q*(Pred*(1/(1+exp(1/G)))+(1-Pred)*(1/(1+exp(-1/G))))^(1-Q);
  if(coop_intent==1){
   log_prob[2]=log_mix(Pred[2],LER[1],LER[2]);
   }else{
   log_prob[2]=log_mix(Pred[2],LER[2],LER[1]);
   }

return log_prob;
}


//# A little helper function for ATFT truth table
int[] updater(int[,] tt, int[] standing, int f_is_g, int coop, int callArb, int arbEr){
  int k;
  int x;
  k = 1;
  if(f_is_g==0) {
   while(k > 0){
   if(
     tt[k,1]==f_is_g &&
     tt[k,2]==standing[1] &&
     tt[k,3]==standing[2] &&
     tt[k,6]==coop &&
     tt[k,7]==callArb &&
     tt[k,12]==arbEr ){
 
    x = k;
    k = 0;
     } else{
    k += 1;
    if(k==81){
     k = 0;
     x = -(1);
    }
  }
 }
}
else{
  while(k > 0){
   if(
     tt[k,1]==f_is_g &&
     tt[k,2]==standing[1] &&
     tt[k,3]==standing[2] &&
     tt[k,4]==coop &&
     tt[k,7]==callArb &&
     tt[k,12]==arbEr ){
 
    x = k;
    k = 0;
     } else{
    k += 1;
    if(k==81){
     k = 0;
     x = -(1);
    }
  }
 }
}

 return(tt[x]);

}