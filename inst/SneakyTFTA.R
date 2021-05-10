//################################################################ Strategy File
//# SneakyTFTA returns the predicted behavior for a sneaky understanding tit-for-tat player

vector Pred_SneakyTFTA(int the_round, int[] arb, int[] arb_err, int[] coop, int[] coop_intent, int[] coop_err, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call (and error)
  
   if(the_round==1){
   	pred[1] = 0;
    pred[2] = 1;
     }else{
     pred[1] = Pred_Arb_simple(the_round, arb, arb_err, coop, coop_err);
     pred[2] = (coop[1]==1 || (arb[2]==1 && arb_err[2]==1))?(1-xi):0;
    }
    
return pred;
}
