//################################################################ Strategy File
//# SneakyWSLS returns the predicted behavior for a sneaky win-stay lose-shift

vector Pred_SneakyWSLS(int the_round, int[] arb, int[] arb_error, int[] coop, int[] coop_intent, int[] coop_err, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call 
 real Y1;
 real Y2;
 real QN;
 
  pred[1] = 0;
  
   if(the_round<3){
    pred[2] = 1;
     }else{
   QN = coop_intent[1]==1 ? 0 : 1;  //# If the focal switches, this will be outcome
   Y1 = (coop_intent[1]+coop[2])==2?1:0;  //# If both cooperate, or
   Y2 = (coop[2]-coop_intent[1])==1?1:0;  //# if focal defected, but opponant cooperated
   pred[2] = (Y1+Y2)>0 ? coop_intent[1] : QN; //# stay, if not, switch.
   pred[2] = pred[2]==1 ? (1-xi) : 0;   //# sneaky
    }
return pred;
}



