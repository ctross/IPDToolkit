//################################################################ Strategy File
//# SneakyATFT returns the predicted behavior for a sneaky arb-tit-for-tat player

vector Pred_SneakyATFT(int the_round, int[] arb, int[] arb_err, int[] coop, int[] coop_intent, int[] coop_err, int[,] tt, real xi){
 vector[2] pred;
 int Q[13];
 int move_knowledge;

 int stand [the_round,2];

 int who[the_round];       //# Who moves each round 1 focal or 0 partner
//# Need to determine whether focal or partner moves each round
//# We know that focal moves in the_round
//# So make a list of who moves each round by working backwards from there
 who[the_round] = 1;
  if(the_round > 1){
   int k;
   
   for( i in 1:(the_round-1)){
    k = the_round-i; //# Go backwards (the_round-1):1
    who[k] = (who[k+1]==1)?0:1;
    }
   }

//# Init standings at good (1), and predicted moves at no arb call (0), and coop (1)
 stand[1,1] = 1;
 stand[1,2] = 1;

 pred[1] = 0;
 pred[2] = 1;

 //# Then go through rounds and update standings by ArbTFT rules
 if(the_round>1){

  for(n in 2:the_round){
    if(who[n-1]==0){
   Q = updater(tt, stand[n-1], who[n-1], coop[n-1], arb[n], arb_err[n]);
    } else{
   Q = updater(tt, stand[n-1], who[n-1], coop_intent[n-1], arb[n], arb_err[n]);
    }

    stand[n,1] = Q[10]; 
    stand[n,2] = Q[11];
    }
 
  if( (coop[the_round-1]==0 && stand[the_round-1,1]==1)  ){
     pred[1] = 1; 
     }

    pred[2] = Q[13];    
}

pred[2] = (pred[2]==1)?(1-xi):0;

return pred;
}


