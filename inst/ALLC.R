//################################################################ Strategy File
//# ALLC returns the predicted behavior for a player who always cooperates

vector Pred_ALLC(int the_round, int[] arb, int[] arb_error, int[] coop, int[] coop_intent, int[] coop_err){
 vector[2] pred; //# arb pred and coop pred
  pred[1] = 0;
  pred[2] = 1;
return pred;
}
