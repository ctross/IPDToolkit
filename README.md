PrisonR
========

Setup
------
Install by running on R:
```{r}
 library(devtools)
 #You might need to turn off warning-error-conversion, because the tiniest warning stops installation
 Sys.setenv("R_REMOTES_NO_ERRORS_FROM_WARNINGS" = "true")
 install_github('ctross/PrisonR')
```

Next, load the package and set a path to where a directory can be created. The setup_folders function will create a directory where some user-editable R and Stan code will be stored.
```{r}
library(PrisonR)
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
 d = simulate_round_robin(
 	   players=c("ALLD","ALLC","RANDY","TFT","TF2T","GTFT","WSLS","TFTA","TF2TA","GTFTA","WSLSA","ATFT"), 
       n_rounds=50,
       error_rate=0.2, 
       arb_error_rate_type_1=0.5, 
       arb_error_rate_type_2=0.2
       )
```
       
