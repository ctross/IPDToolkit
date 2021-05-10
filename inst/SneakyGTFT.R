//################################################################ Strategy File
//# SneakyGTFT returns the predicted behavior for a sneaky generous tit-for-tat player

vector Pred_SneakyGTFT(int the_round, int[] arb, int[] arb_error, int[] coop, int[] coop_intent, int[] coop_err, real psi, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call 
  pred[1] = 0;
   if(the_round==1){
    pred[2] = 1;
     }else{
    pred[2] = (coop[1]==1)?(1-xi):psi;
    }
return pred;
}
