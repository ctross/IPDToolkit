IPDToolkit
========
<img align="right" src="https://github.com/ctross/IPDToolkit/blob/main/logo.png" alt="logo" width="170"> 

**IPDToolkit** is an R package designed to facilitate the simulation and analysis of iterated prisoner's dilema games using Bayesian discrete mixture models.

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
 p1 = sequence_plot(Focal="ATFT", Partner="ATFT", seed=14534, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5)
 p2 = sequence_plot(Focal="TFT", Partner="TFT",   seed=14534, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5)
 p3 = sequence_plot(Focal="TFT", Partner="GTFT",  seed=3522143, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5)
 p4 = sequence_plot(Focal="TFT", Partner="TFTA",  seed=145234, n_rounds=10, error_rate=0.2, arb_error_rate_type_1=0.5, arb_error_rate_type_2=0.5)

 ggsave("ATFTvATFT.pdf", p1, width=8*0.9,height=8*0.9)
 ggsave("TFTvTFT.pdf", p2, width=8*0.9,height=8*0.9)
 ggsave("TFTvGTFT.pdf", p3, width=8*0.9,height=8*0.9)
 ggsave("TFTvTFTA.pdf", p4, width=8*0.9,height=8*0.9)
```

To run a large round-robin, run:
```{r}
set.seed(1)
 d = simulate_round_robin(players=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT"), 
       n_rounds=50,
       error_rate=0.2, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.2
       )
```
Then, ensure that the latent mixture model allows us to recover strategies:
```{r}
create_stan_models(path)
f2a = fit_IPD_optim(d,n_strategies=12)
ex2a = visualize_IPD_results(f2a, d, color="darkred", smart_sort=TRUE)
ggsave("Heat_optim.pdf", ex2a, width=8*0.9,height=8*0.9)
```

To run a bunch of random matchups, where strategy use and sneak rate vary as a function of an individual-level covariate, run:
```{r}
set.seed(1)
N = 60
Z = rbinom(N,size=1, prob=0.5)
strategies = c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT")
A = rnorm(12,0,0.5)
B = rep(0,12)
B[c(4,8)] = 2
B[c(6,10)] = -2
strat = rep(NA, N)

C <- c(-3.7, 2.5)
dispersion <- 40

Xi = rep(NA, N)

for(i in 1:N){
     Q = A + B*Z[i]	
     Q[1] = 0
     strat[i] = strategies[which(rmultinom(1, size=1, prob=softmax(Q))==1)]
     Xi[i] = rbeta(1,logistic(C[1] + C[2]*Z[i] )*dispersion, (1-logistic(C[1] + C[2]*Z[i] ))*dispersion)
     }
table(strat,Z)
plot(Xi~Z)

 d = simulate_round_robin(
 	   players=strat,
       n_rounds=30,
       error_rate=0.2,
       arb_error_rate_type_1=0.5,
       arb_error_rate_type_2=0.2,
       mode="random",
       n_games = 160,
       xi=Xi
       )
 ```
And again check performance of our models:
```{r}
create_stan_models(path)
f3a = fit_IPD_optim(d,covariates=as.matrix(Z),n_strategies=12)

babynames = c("Olivia","Gianna","Oliver","Elijah","William","Layla","Chloe","Aria","Mia","Alexander",
	          "Mason","Michael","Ethan","Daniel","Jacob","Logan","Jackson","Levi","Sebastian","Mateo",
	          "Jack","Sophia","Camila","Aiden","Samuel","Penelope","John","David","Wyatt","Matthew",
	          "Luke","Asher","Carter","Julian","Scarlett","Leo","Jayden","Mia","Isaac","Abigail","Ajira",
	          "Hudson","Luna","Ezra","Thomas","Charles","Christopher","Jaxon","Maverick","Josiah","Isaiah",
	          "Andrew","Elias","Nora","Nathan","Caleb","Ryan","Adrian","Miles","Eli")

d$players = paste0(babynames,"(",strat,")")

ex3a = visualize_IPD_results(f3a, d, color="darkred", smart_sort=TRUE)
ggsave("Heat_optim_covariates.pdf", ex3a, width=8*0.9,height=8*0.9)
```
