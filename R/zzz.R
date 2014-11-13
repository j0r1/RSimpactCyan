.onLoad <- function(libname, pkgname)
{
	print("onLoad")

	fileName <- system.file("simpactStart.py", package=pkgname)
	dirName <- dirname(fileName)

	python.exec(paste("import sys; sys.path.append('",dirName,"')", sep=""))
	python.load(fileName)
	python.exec("simpactPythonInstance = SimpactPython()")
}

.onAttach <- function(libname, pkgname)
{
	print("onAttach")

	data("simpact.sa2003")
	data("simpact.sa2013")
}
