//################################################################ Strategy File
//# SneakyWSLSA returns the predicted behavior for an Sneaky understanding win-stay lose-shift

vector Pred_SneakyWSLSA(int the_round, int[] arb, int[] arb_err, int[] coop, int[] coop_intent, int[] coop_err, real xi){
 vector[2] pred; //# Coop call prediction and conditional on actual arb call 
 real Y1;
 real Y2;
 real QN;
 real QS;
 real coopintS;
 real coopintO;
   
   if(the_round==1){
   pred[1] = 0; }
   else{
   pred[1] = Pred_Arb_simple(the_round, arb[2:3], arb_err[2:3], coop[2:3], coop_err[2:3]);
       }
       
   if(the_round<3){
      pred[2] = 1;
     }else{
   if(arb[3]==1 && arb_err[3]==1){
    QN = coop_intent[1]==1 ? 0 : 1;  //# If the focal switches, this will be outcome
    Y1 = (coop_intent[1] + 1)==2?1:0;  //# If both cooperate, or
    Y2 = (1 - coop_intent[1])==1?1:0;  //# if focal defected, but opponant cooperated
    pred[2] = (Y1+Y2)>0 ? coop_intent[1] : QN; //# stay, if not, switch.
    pred[2] = pred[2]==1 ? (1-xi) : 0;   //# sneaky
   } 

   else{
    QN = coop_intent[1]==1 ? 0 : 1;  //# If the focal switches, this will be outcome
    Y1 = (coop_intent[1]+coop[2])==2?1:0;  //# If both cooperate, or
    Y2 = (coop[2]-coop_intent[1])==1?1:0;  //# if focal defected, but opponant cooperated
    pred[2] = (Y1+Y2)>0 ? coop_intent[1] : QN; //# stay, if not, switch.
    pred[2] = pred[2]==1 ? (1-xi) : 0;   //# sneaky
   }  

    }
return pred;
}




