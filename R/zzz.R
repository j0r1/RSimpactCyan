.onLoad <- function(libname, pkgname)
{
	fileName <- system.file("simpactStart.py", package=pkgname)
	dirName <- dirname(fileName)

	python.exec(paste("import sys; sys.path.append('",dirName,"')", sep=""))
	python.load(fileName)
	python.exec("simpactPythonInstance = SimpactPython()")
}

.onAttach <- function(libname, pkgname)
{
	data("simpact.sa2003")
	data("simpact.sa2013")
}
