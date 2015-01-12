pkg.env <- new.env()
pkg.env$internalPythonScriptFileName <- ""
pkg.env$internalCheckLoadedFlag <- FALSE

.onLoad <- function(libname, pkgname)
{
	pkg.env$internalPythonScriptFileName <- system.file("simpactStart.py", package=pkgname)
}

