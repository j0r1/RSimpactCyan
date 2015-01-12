pkg.env <- new.env()
pkg.env$internalPythonScriptFileName <- ""
pkg.env$internalCheckLoadedFlag <- FALSE

.onLoad <- function(libname, pkgname)
{
	pkg.env$internalPythonScriptFileName <- system.file("simpactStart.py", package=pkgname)
}

.onAttach <- function(libname, pkgname)
{
	data("simpact.sa2003")
	data("simpact.sa2013")
}
