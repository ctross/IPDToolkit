#' A function to load some data when the package opens.
#'
#' @export

.onAttach <- function(libname=NULL, pkgname="PrisonR") {
  packageStartupMessage("Welcome to PrisonR. Get yo game on.")

}
