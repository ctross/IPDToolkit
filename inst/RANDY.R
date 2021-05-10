//################################################################ Strategy File
//# RANDY returns the predicted behavior for a player who cooperate at random

vector Pred_RANDY(int the_round, int[] arb, int[] arb_error, int[] coop, int[] coop_intent, int[] coop_err, real pi){
 vector[2] pred; //# arb pred and coop pred
  pred[1] = 0;
  pred[2] = pi;
return pred;
}
