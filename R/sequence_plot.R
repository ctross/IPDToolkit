#' Plot a gameplay sequence between 2 strategies.
#'
#' @param 
#' Focal A strategy file to be used by the focal player. Name must match a legal function file: i.e., "ALLC", "TFT", "GTFT", "TFTA", etc.
#' @param 
#' Partner A strategy file to be used by the partner player. Name must match a legal function file: i.e., "ALLC", "TFT", "GTFT", "TFTA", etc.
#' @param 
#' seed A seed for the random number generator for reproducible plots.
#' @param 
#' n_rounds Number of rounds to plot.
#' @param 
#' error_rate The rate at which the computer introduces errors of the form C to D.
#' @param 
#' arb_error_rate_type_1 The arbitrators rate of failing to detect a real error.
#' @param 
#' arb_error_rate_type_2 The arbitrators rate of claiming an error was a true defection.
#' @param 
#' colors Colors for the palette.
#' @return A ggplot object showing two strategies playing.
#' @export

 sequence_plot = function(Focal="ATFT", Partner="ATFT", seed=1234, n_rounds=20, error_rate=0.1, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5, 
                         colors=c("No" = "#ffeda0", "Defect" = "#440154FF", "Good Standing" = "#7fcdbb", "Bad Standing" = "black", "Cooperate" = "white", "Yes" = "#0c2c84"))
{
set.seed(seed)
 n_rounds = n_rounds + 1
 d = simulate_round_robin(players=rep(c(Focal,Partner,Partner) , 1), 
                          n_rounds=n_rounds,
                          error_rate=error_rate, 
                          arb_error_rate_type_1=arb_error_rate_type_1,
                          arb_error_rate_type_2=arb_error_rate_type_2)
 rounds = n_rounds
                  
 d$moves$coop_intent = ifelse(d$moves$coop_err==1 & d$moves$coop==0,1 ,d$moves$coop)                             # Intent of player
 
 d2 <- d$moves 
 n_rounds_full <- rounds*2
 d2 <- d2[which(d2$g_round>0),]
 d2 <- d2[1:n_rounds_full,]
 d2$coop2 <- (ifelse(d2$coop==0,"Defect","Cooperate"))
 d2$coop_err2 <- (ifelse(d2$coop_err==0,"No","Yes"))
 d2$round2 <-factor(rep(1:n_rounds_full,each=1))
 d2$actor_id2 <-factor(d2$actor_id)
 d2$arb2 <- (ifelse(d2$arb==0,"No","Yes"))
 d2$arb_err2 <- (ifelse(d2$arb_err==0,"No","Yes"))
 d2$coop_intent2 <- (ifelse(d2$coop_intent==0,"Defect","Cooperate"))

 d2$s1f2 <- ifelse(d2$stand_1_Focal==0,"Bad Standing","Good Standing")
 d2$s1a2 <- ifelse(d2$stand_1_Alter==0,"Bad Standing","Good Standing")

 d2$s2f2 <- c(ifelse(d2$stand_mr_Focal==0,"Bad Standing","Good Standing"))
 d2$s2a2 <- c(ifelse(d2$stand_mr_Alter==0,"Bad Standing","Good Standing")) 

 d3 <- data.frame(round2 = c(d2$round2, d2$round2, d2$round2, d2$round2, d2$round2, d2$round2, d2$round2, d2$round2, d2$round2),
                  actor_id2 = c(d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2,d2$actor_id2),
                var= c(d2$s2f2, d2$s2a2, d2$arb2, d2$arb_err2, d2$s1f2,d2$s1a2,  d2$coop_intent2, d2$coop_err2, d2$coop2),
                key = c(
                        rep("1a. Focal Standing Evaluation Pre-Arbitration  (from focal perspective)",n_rounds_full),
                        rep("1b. Alter Standing Evaluation Pre-Arbitration  (from focal perspective)",n_rounds_full), 
                        rep("2. Calls Arbitrator",n_rounds_full), 
                        rep("3. Arbitrator Declares Error",n_rounds_full), 
                        rep("4a. Focal Standing Evaluation Post-Arbitration (from focal perspective)",n_rounds_full),
                        rep("4b. Alter Standing Evaluation Post-Arbitration (from focal perspective)",n_rounds_full),
                        rep("5. Cooperative Intent",n_rounds_full),  
                        rep("6. System Introduces Error",n_rounds_full), 
                        rep("7. Observable Cooperation",n_rounds_full)
                        )
      )
 d3$var <- factor( d3$var) # TGF added 6/14/2020
 levels(d3$var) <- c(levels(d3$var),"No", "Defect", "Good Standing", "Bad Standing", "Cooperate", "Yes") # CTR added 5/7/2021
 
 d3$var <- factor( d3$var, levels( d3$var)[c(4,1,2,3,5,6)])

 # Plotting it
 p1=ggplot(d3, aes(x = factor(round2), stratum = var, alluvium = actor_id2, fill = var, label = var, color = factor(actor_id2))) +
  scale_fill_manual(values = colors, 
    name = "", drop = FALSE, na.translate=FALSE) + 
  #geom_flow(stat = "alluvium", lode.guidance = "rightleft", color = "darkgray") +
  geom_stratum(size=1.1) +  theme(panel.grid.minor = element_blank()) + theme(panel.grid.major = element_blank()) + 
  theme(strip.background = element_rect(fill = "grey35", color = "white", size = 1),
        strip.text = element_text(colour = "white")) + theme(panel.background = element_blank()) +  
  theme(legend.position = "bottom") +  scale_colour_manual(values = c("grey70", "black"),labels=c(Focal, Partner), name = "Players: ") +
  ggtitle("") + facet_wrap(key ~ . , scales = "fixed",ncol=1) +
  xlab("Round") + 
  theme(axis.title.y=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) + 
       scale_x_discrete(breaks=c(1:n_rounds_full),
        labels=paste0(rep(1:rounds, each=2),rep(c(".a", ".b"), rounds))
        ) + guides(shape = guide_legend(fill = 2),color = guide_legend(order = 1))
 p1
 return(p1)
}
