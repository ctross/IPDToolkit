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

```{r}
library(PrisonR)
path = "C:\\Users\\Mind Is Moving\\Desktop"
setup_folders(path,import_code=TRUE)
```
