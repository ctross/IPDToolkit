//################################################################ Strategy File
//# SneakyTF2T returns the predicted behavior for a sneaky tit-for-2-tats player

vector Pred_SneakyTF2T(int the_round, int[] arb, int[] arb_err, int[] coop, int[] coop_intent, int[] coop_err, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call (and error)
  pred[1] = 0;
   if(the_round<4){
    pred[2] = 1;
    }else{
    pred[2] = (coop[1]==1 || coop[3]==1)?(1-xi):0;
    }
return pred;
}
