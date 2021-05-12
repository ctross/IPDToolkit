#' A function to create the main directory used in the workflow.
#'
#' This function allows you to build the directories for editing R and Stan code.
#' @param 
#' path Full path to where folder will be stored. This folder will be called "PrisonersDilema".
#' @param 
#' import_code If TRUE, this will import R and Stan template code from the PrisonR R package, and save it in the new directory. 
#' @param
#' overwrite Setting this to TRUE will OVERWRITE existing files!
#' @export
         
setup_folders = function(path=path, import_code=TRUE, overwrite=FALSE){
  if (!dir.exists(file.path(path, "PrisonersDilema"))) {
  dir.create(file.path(path, "PrisonersDilema"))
  
  dir.create(file.path(paste0(path,"/","PrisonersDilema"),"DataTables"))
  dir.create(file.path(paste0(path,"/","PrisonersDilema"),"StrategiesR"))
  dir.create(file.path(paste0(path,"/","PrisonersDilema"),"StrategiesStan"))
  dir.create(file.path(paste0(path,"/","PrisonersDilema"),"StanCode"))
  }

   if(import_code==TRUE){
  file.copy(paste0(path.package("PrisonR"),"/","WACKO.R"), paste0(path,"/","PrisonersDilema","/","StrategiesR/","WACKO.R"), overwrite=overwrite)

  file.copy(paste0(path.package("PrisonR"),"/","truth_table_atft.csv"), paste0(path,"/","PrisonersDilema","/","DataTables/","truth_table_atft.csv"), overwrite=overwrite)

  file.copy(paste0(path.package("PrisonR"),"/","Functions.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Functions.R"), overwrite=overwrite)
  
  file.copy(paste0(path.package("PrisonR"),"/","Data.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Data.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","Parameters.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Parameters.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","Model.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Model.R"), overwrite=overwrite)

  file.copy(paste0(path.package("PrisonR"),"/","Data_CovariateModel.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Data_CovariateModel.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","Parameters_CovariateModel.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Parameters_CovariateModel.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","Model_CovariateModel.R"), paste0(path,"/","PrisonersDilema","/","StanCode/","Model_CovariateModel.R"), overwrite=overwrite)

  file.copy(paste0(path.package("PrisonR"),"/","ALLC.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","ALLC.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","ALLD.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","ALLD.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","RANDY.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","RANDY.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyTFT.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyTFT.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyGTFT.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyGTFT.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyTF2T.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyTF2T.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyWSLS.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyWSLS.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyTFTA.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyTFTA.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyGTFTA.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyGTFTA.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyTF2TA.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyTF2TA.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyWSLSA.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyWSLSA.R"), overwrite=overwrite)
  file.copy(paste0(path.package("PrisonR"),"/","SneakyATFT.R"), paste0(path,"/","PrisonersDilema","/","StrategiesStan/","SneakyATFT.R"), overwrite=overwrite)
  

  tt <- read.csv(paste0(path.package("PrisonR"),"/","truth_table_atft.csv"))
  tt$error_called <- ifelse((tt$partners_observed_move != tt$partners_move_arb_declared) & tt$partners_observed_move == 0, 1, 0)
  tt$error_called[is.na(tt$error_called)] <- 0
  tt$move_choice <- ifelse(tt$new_focal_standing==0 | tt$new_partner_standing==1,1,0) 
  
  tt <<- tt # cringe
  }

}                                                   




