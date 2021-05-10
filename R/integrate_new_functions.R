#' A function to add new strategy files to the namespace
#'
#' @param 
#' path Full path to "PrisonersDilema"
#' @export
         
integrate_new_functions = function(path=path){

 files <- list.files(path=paste0(path,"/StrategiesR"), pattern='*.R', full.names = TRUE)
 
 for(i in 1:length(files)){
   source(files[i])
  }

}                                                   




