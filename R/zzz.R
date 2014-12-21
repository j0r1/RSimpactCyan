.onLoad <- function(libname, pkgname)
{
	fileName <- system.file("simpactStart.py", package=pkgname)
	dirName <- dirname(fileName)

	pithon.exec(paste("import sys; sys.path.append('",dirName,"')", sep=""), instance.name="simpact")
	pithon.load(fileName, instance.name="simpact")
	pithon.exec("simpactPythonInstance = SimpactPython()", instance.name="simpact")
}

.onAttach <- function(libname, pkgname)
{
	data("simpact.sa2003")
	data("simpact.sa2013")
}
