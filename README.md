IPDToolkit
========
<img align="right" src="https://github.com/ctross/IPDToolkit/blob/main/logo.png" alt="logo" width="170"> 

**IPDToolkit** is an R package designed to facilitate the simulation and analysis of iterated prisoner's dilema games using Bayesian discrete mixture models.

To address theoretical questions, IPDToolkit provides a Monte Carlo simulation engine that can be used to generate play between arbitrary strategies in the IPD with arbitration and assess expected pay-offs.  To address empirical questions, IPDToolkit provides customizable, Bayesian finite-mixture models that can be used to identify the strategies responsible for generating empirical game-play data. We present a complete workflow using IPDToolkit to teach end-users its functionality.

-----

Setup
------
Install by running on R:
```{r}
 library(devtools)
 #You might need to turn off warning-error-conversion, because the tiniest warning stops installation
 Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")
 install_github('ctross/IPDToolkit')
```

Next, load the package and set a path to where a directory can be created. The setup_folders function will create a directory where some user-editable R and Stan code will be stored.
```{r}
library(IPDToolkit)
path = "C:\\Users\\Mind Is Moving\\Desktop"
setup_folders(path,import_code=TRUE)
```

Once this directory is created, the user can add any new strategy files into the folder "PrisonersDilema/StrategiesR". These new files can then be added to the namespace by running:
```{r}
integrate_new_functions(path)
```


Simulating iterated prisoner's dilema game-play
------
To visualize play between specific strategy types, use the sequence_plot function:
```{r}
###################################### Example 1, plot move sequences
# Plot specific strategies against each other
colors = c("No" = "#ffeda0", "Defect" = "darkred", "Good Standing" = "#7fcdbb", "Bad Standing" = "grey13", "Cooperate" = "white", "Yes" = "#0c2c84")
p1 = sequence_plot(Focal="TFT", Partner="TFT",   seed=14534, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5, colors=colors)
p2 = sequence_plot(Focal="TFT", Partner="GTFT",  seed=3522143, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5, colors=colors)
p3 = sequence_plot(Focal="TFT", Partner="TFTA",  seed=145234, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5, colors=colors)
p4 = sequence_plot(Focal="ATFT", Partner="ATFT", seed=14534, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5, colors=colors)

ggsave("TFTvTFT.pdf", p1, width=8*0.9,height=8*0.9)
ggsave("TFTvGTFT.pdf", p2, width=8*0.9,height=8*0.9)
ggsave("TFTvTFTA.pdf", p3, width=8*0.9,height=8*0.9)
ggsave("ATFTvATFT.pdf", p4, width=8*0.9,height=8*0.9)

```

To run a round-robin tournament, run:
```{r}
###################################### Example 2, demonstrate smart sort
set.seed(1)
 d = simulate_round_robin(
       players=c("TFTA","TF2TA","TFT","GTFTA","ATFT","ALLC","RANDY","TFT","TFTA","TFTA","TF2TA","TFT"), 
       n_rounds=30,
       error_rate=0.2, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.25
       )
```
Then, ensure that the latent mixture model allows us to recover strategies:
```{r}
create_stan_models(path)
f1 = fit_IPD_optim(d,n_strategies=12)

d$players = c("Liam","Olivia","Lucas","Charlotte","Emma","Mia","Benjamin","Elijah","Ava","Sophia","Harper","Alexander")

ex1a = visualize_IPD_results(f1, d, color="darkred")
ex1b = visualize_IPD_results(f1, d, color="darkred", smart_sort=TRUE) # Groups by ML Strategy

ggsave("Heat_nosort.pdf", ex1a, width=8*0.9,height=8*0.9)
ggsave("Heat_sort.pdf", ex1b, width=8*0.9,height=8*0.9)
```

To compare fitting via MCMC and Optim, run:
```{r}
###################################### Example 3, demonstrate MCMC versus Optim
set.seed(1)
 d = simulate_round_robin(
       players=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT"), 
       n_rounds=30,
       error_rate=0.2, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.2
       )

create_stan_models(path)
f2a = fit_IPD_optim(d,n_strategies=12) # Really fast (for this kind of model)   
ex2a = visualize_IPD_results(f2a, d, color="darkred", smart_sort=TRUE)

ggsave("Heat_optim.pdf", ex2a, width=8*0.9,height=8*0.9)

f2b = fit_IPD_mcmc(d,n_strategies=12) # Hella slow, but better estimates
 ```

To run a bunch of random matchups, where strategy use and sneaky defection rate vary as a function of an individual-level covariate, run:
```{r}
###################################### Example 4, covariates
set.seed(1337420)
N = 60
Z = rbinom(N,size=1, prob=0.33)
strategies = c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT")

A = matrix(NA, nrow=N, ncol=12)
for(i in 1:N)
A[i,] = rnorm(12,0,0.5)
B = rep(0,12)
B[c(4,8)] = 2
B[c(6,10)] = -2.5
strat <- rep(NA, N)

C <- c(-3.7, 2.5)
C_offset = rnorm(N,0,0.5)

Xi <- rep(NA, N)

for(i in 1:N){
     Q = A[i,] + B*Z[i] 
     Q[1] = 0
     strat[i] = strategies[which(rmultinom(1, size=1, prob=softmax(Q))==1)]
     Xi[i] = logistic( C[1] + C[2]*Z[i] + C_offset[i] )
     }
table(strat,Z)
plot(Xi~Z)

 d = simulate_round_robin(
         players=strat,
       n_rounds=30,
       error_rate=0.23,
       arb_error_rate_type_1=0.5,
       arb_error_rate_type_2=0.2,
       mode="random",
       n_games = 180,
       xi=Xi
       )

create_stan_models(path)
f3a = fit_IPD_optim(d,covariates=as.matrix(Z),n_strategies=12)

babynames = c("Olivia","Gianna","Oliver","Elijah","William","Layla","Chloe","Aria","Mia","Alexander",
              "Mason","Michael","Ethan","Daniel","Jacob","Logan","Jackson","Levi","Sebastian","Mateo",
              "Jack","Sophia","Camila","Aiden","Samuel","Penelope","John","David","Wyatt","Matthew",
              "Luke","Asher","Carter","Julian","Scarlett","Leo","Jayden","Mia","Isaac","Abigail","Ajira",
              "Hudson","Luna","Ezra","Thomas","Charles","Christopher","Jaxon","Maverick","Josiah","Isaiah",
              "Andrew","Elias","Nora","Nathan","Caleb","Ryan","Adrian","Miles","Eli")

d$players = paste0(babynames,"(",strat,")")

ex3a = visualize_IPD_results(f3a, d, color="darkred", smart_sort=TRUE,
           dashes_at=c(0,4.5, 8.5, 9.5, 19.5, 22.5, 27.5, 30.5, 43.5, 46.5, 51.5, 52.5))
ex3a

ggsave("Heat_optim_covariates.pdf", ex3a, width=8*0.9,height=10*0.9)


xi_relevant = round(rowSums(exp(f3a$par$ThetaHat)[,c(4:5,7:12)]),2)==1

cor(Xi[which(xi_relevant)],f3a$par$xi[which(xi_relevant)])

postres = data.frame(Real=Xi[which(xi_relevant)], Estimated=f3a$par$xi[which(xi_relevant)])

resdots = ggplot(postres, aes(x=Real, y=Estimated)) + 
  geom_point(color="darkred")+
  geom_smooth(method=lm,col="black") + labs(x= expression("Real "*xi*" "), y= expression("Estimated "*xi*" ") ) 

ggsave("Xi_optim_covariates.pdf", resdots, width=4*0.9,height=4*0.9)
```

Be careful to ensure that relevant strategies were not omiited, and code your own strategy files:
```{r}
###################################### Example 4, omitted strategies
set.seed(1)
 d = simulate_round_robin(
       players=c("WSLS","GLUM","TF2TA","ALLD","ATFT","GLUM","WSLS","TFT","TFTA","GLUM","TFTA","GLUM","TFT","ALLC", "GLUM"), 
       n_rounds=30,
       error_rate=0.2, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.25
       )

 namynames = c("Sophia","Camila","Aiden","Penelope","David","Zora","Wyatt","Matthew","Ajira","John","Katie","BillyBob","Forest","Laura","Zara")
 d$players = paste0(namynames,"(",d$players,")")

 create_stan_models(path)
 f4a = fit_IPD_optim(d,n_strategies=12)
 ex4a = visualize_IPD_results(f4a, d, color="darkred", smart_sort=TRUE)
 ggsave("Heat_glum_base.pdf", ex4a, width=8*0.9,height=8*0.9)

 # Add in the GLUM file as shown in the section "Modifying the Base Model"
 # Add strategy file, and edit Model.R
 create_stan_models(path) # Rebuilt
 f4b = fit_IPD_optim(d,n_strategies=13) # Refit
 ex4b = visualize_IPD_results(f4b, d, color="darkred", smart_sort=TRUE,
           strategy_set=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT","GLUM"))

 ggsave("Heat_glum_mod.pdf", ex4b, width=8*0.9,height=8*0.9)
```

Tune the priors to improve classification of strategies:
```{r}
###################################### Example 5, priors
# Its OK to keep GLUM for now
set.seed(714)
 d = simulate_round_robin(
       players=c("WSLS","RANDY","TF2TA","GTFT","RANDY","RANDY","RANDY","GTFT","GTFTA","RANDY","GTFTA","RANDY","GTFT","ALLC"), 
       n_rounds=20,
       error_rate=0.15, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.25
       )

 namynames = c("Hudson","Camila","Luna","Ezra","David","Zara","Thomas","Matthew","Ajira","Jaxon","Katie","Maverick","Isaiah","Laura")
 d$players = paste0(namynames,"(",d$players,")")

 create_stan_models(path)
 f5a = fit_IPD_optim(d,n_strategies=13)
 ex5a = visualize_IPD_results(f5a, d, color="darkred", smart_sort=TRUE,
           strategy_set=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT","GLUM"))
 ggsave("Heat_randy_base.pdf", ex5a, width=8*0.9,height=8*0.9)

# Now open Model.R and set tigher priors as dewcribed in Fig 7
 create_stan_models(path)
 f5b = fit_IPD_optim(d,n_strategies=13)
 ex5b = visualize_IPD_results(f5b, d, color="darkred", smart_sort=TRUE,
          strategy_set=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT","GLUM"))
 ggsave("Heat_randy_goodpriors.pdf", ex5b, width=8*0.9,height=8*0.9)
```
