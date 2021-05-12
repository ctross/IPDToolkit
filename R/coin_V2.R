#' A helper function to flip a random coin after a few rounds of fixed results. This prevents sequential computer introduced errors.
#'
#' @param 
#' p The probability of a head.
#' @param 
#' i The round ID code.
#' @param 
#' laged A window of time to check if the computer has already introduced an error.
#' @export

coin_V2 = function(p,i,laged)
{
   if(i<5){
    x = 0
    }
   else{
    if(sum(laged[(i-4):i])>0){
    x = 0}
     else{
    x = rbinom(1, size=1, p)
     }
   }
   return(x) 
}
