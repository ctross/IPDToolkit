//################################################################ Strategy File
//# SneakyTF2TA returns the predicted behavior for a sneaky understanding tit-for-2-tats player

vector Pred_SneakyTF2TA(int the_round, int[] arb, int[] arb_err, int[] coop, int[] coop_intent, int[] coop_err, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call (and error)

    if(the_round==1){
   	pred[1] = 0;
   	}else{
    pred[1] = Pred_Arb_simple(the_round, arb[3:4], arb_err[3:4], coop[3:4], coop_err[3:4]);
    }

   if(the_round<4){
    pred[2] = 1;
    }else{
    pred[2] = (coop[1]==1 || coop[3]==1 || (arb[2]==1 && arb_err[2]==1) || (arb[4]==1 && arb_err[4]==1) )?(1-xi):0;
    }
   
return pred;
}
