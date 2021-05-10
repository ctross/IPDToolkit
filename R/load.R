#' A function to load some data when the package opens
#'
#' @param 
#' path Full path to where files will be stored. 
#' @export

.onAttach <- function(libname=NULL, pkgname="PrisonR") {
  packageStartupMessage("Welcome to PrisonR. Get yo game on.")

}
