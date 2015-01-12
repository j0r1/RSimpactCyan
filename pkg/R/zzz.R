.onLoad <- function(libname, pkgname)
{
	fileName <- system.file("simpactStart.py", package=pkgname)
	dirName <- dirname(fileName)

	pithon.load(fileName, instance.name="simpact")
}

.onAttach <- function(libname, pkgname)
{
	data("simpact.sa2003")
	data("simpact.sa2013")
}
