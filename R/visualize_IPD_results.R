#' Plot a heatmap that shows the distribution of posterior probability over strategies for each player.
#'
#' @param 
#' fit The results returned by either fit_IFD_optim or fit_IFD_mcmc.
#' @param 
#' d The data fed into either fit_IFD_optim or fit_IFD_mcmc.
#' @param 
#' mode Either 'optim' or 'mcmc'. 
#' @param 
#' smart_sort Sort to cluster by strategy?
#' @param 
#' color The color of the 'hot' end of the heatmap.
#' @param 
#' strategy_set The list of strategies in the Stan model. The order here must match the order of strategies in the Stan file.
#' @param 
#' dashes_at A list of locations to plot dashed lines.
#' @return A ggplot object. Heatmap.
#' @export

visualize_IPD_results = function(fit, d, mode="optim", smart_sort=FALSE, color="#440154FF",
	                                strategy_set=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT"),
	                                dashes_at=c(0))
{
   if(mode=="optim"){
   # Pull out theta means and merge with player table
    theta <- exp(fit$par$ThetaHat)
   }

   if(mode=="mcmc"){
   	theta <- extract(fit, pars="ThetaHat")$ThetaHat
    theta <- exp(theta)
    theta <- apply(theta, 2:3, mean) 
   }

   if(! mode %in% c("optim","mcmc"))stop(" 'mode' must be 'optim' or 'mcmc'. ")

   player_set = d$player
   sortforce <- function(x) factor(x, levels = unique(x))

   # Sorting
   if(smart_sort==TRUE){
    whichmax <- function(X){
     Y <- c()
     for(i in 1:nrow(X)){
     Y[i] <- which(X[i,]==max(X[i,])) 
      }
     return(Y)
     }

    vwm_theta <- wm_theta <- whichmax(theta)
    for(i in 1:length(vwm_theta)) vwm_theta[i] <- theta[i,wm_theta[i]]

    theta <- theta[order(wm_theta,vwm_theta),]

    player_set = d$player[order(wm_theta,vwm_theta)]
   }
   
   df1 <- data.frame(PID=rep(player_set, length(strategy_set)),
	                 Probability=round(c(as.matrix(theta)),4), 
	                 Strategy=rep(strategy_set, each=length(d$player))
	                 )

   xzx <- ggplot(df1, aes(x=sortforce(Strategy), y=sortforce(PID), fill = Probability)) + geom_raster()  +
           scale_fill_gradient2(low="white", high=color, guide="colorbar", name = "Strategy Probability: \n ") + 
           theme(panel.grid.minor = element_blank()) + theme(panel.grid.major = element_blank()) + 
           theme(strip.background = element_rect(fill = "grey35", color = "white", size = 1),
            strip.text = element_text(colour = "white")) + 
           theme(panel.background = element_blank()) +  ylab("Player ID") +  xlab("Inferred strategy") +
           theme(legend.position = "bottom") + guides(fill = guide_colourbar( barwidth = 15)) + 
           geom_hline(yintercept=dashes_at,linetype=3, color="grey30")
   return(xzx)
}

