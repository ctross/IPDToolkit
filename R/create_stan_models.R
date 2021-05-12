#' A function to create the main models used in the workflow.
#'
#' This function allows you to build Stan models with minimum user input.
#' @param 
#' path Full path to where files will be stored. 
#' @export

create_stan_models = function(path=path){
 strat_files <- list.files(paste0(path,"/","PrisonersDilema","/","StrategiesStan"),pattern='*.R',full.names = TRUE)

 stan_functs <- paste0(path,"/","PrisonersDilema/","StanCode/","Functions.R")
 stan_data <- paste0(path,"/","PrisonersDilema/","StanCode/","Data.R")
 stan_params <- paste0(path,"/","PrisonersDilema/","StanCode/","Parameters.R")
 stan_mods <- paste0(path,"/","PrisonersDilema/","StanCode/","Model.R")

 stan_data_c <- paste0(path,"/","PrisonersDilema/","StanCode/","Data_CovariateModel.R")
 stan_params_c <- paste0(path,"/","PrisonersDilema/","StanCode/","Parameters_CovariateModel.R")
 stan_mods_c <- paste0(path,"/","PrisonersDilema/","StanCode/","Model_CovariateModel.R")

############################################################ Basic Model
 Code <- c()
 Code[1] <- "functions{\n"
 Code[2] <- readChar(stan_functs, file.info(stan_functs)$size)
 
for(i in 1:length(strat_files))
 Code[i+2] <- readChar(strat_files[i], file.info(strat_files[i])$size)
 
 Code[2+length(strat_files)+1] <- "\n}\n"
 
 Code[2+length(strat_files)+2] <- readChar(stan_data, file.info(stan_data)$size)
 Code[2+length(strat_files)+3] <- readChar(stan_params, file.info(stan_params)$size)
 Code[2+length(strat_files)+4] <- readChar(stan_mods, file.info(stan_mods)$size)


write(Code, file = paste0(path,"/PrisonersDilema/StanCode/model_code.stan"), append = FALSE)

############################################################ Covariate Model
 Code <- c()
 Code[1] <- "functions{\n"
 Code[2] <- readChar(stan_functs, file.info(stan_functs)$size)
 
for(i in 1:length(strat_files))
 Code[i+2] <- readChar(strat_files[i], file.info(strat_files[i])$size)
 
 Code[2+length(strat_files)+1] <- "\n}\n"
 
 Code[2+length(strat_files)+2] <- readChar(stan_data_c, file.info(stan_data_c)$size)
 Code[2+length(strat_files)+3] <- readChar(stan_params_c, file.info(stan_params_c)$size)
 Code[2+length(strat_files)+4] <- readChar(stan_mods_c, file.info(stan_mods_c)$size)


write(Code, file = paste0(path,"/PrisonersDilema/StanCode/model_code_covariates.stan"), append = FALSE)
}

