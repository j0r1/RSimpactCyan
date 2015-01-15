
checkLoaded <- function()
{
	if (!pkg.env$internalCheckLoadedFlag)
	{
		pkg.env$internalCheckLoadedFlag <- TRUE
		#print("Doing first pithon.load")
		#print(pkg.env$internalPythonScriptFileName)
		pithon.load(pkg.env$internalPythonScriptFileName, instance.name="simpact")
	}
}

simpact.available <- function()
{
	if (!pithon.available(instance.name="simpact"))
		return(FALSE)
	
	checkLoaded()

	if (!pithon.call('isSimpactCyanAvailable', instance.name="simpact"))
		return(FALSE)

	return(TRUE)
}

check.available <- function()
{
	if (!simpact.available())
		stop("Either the Simpact Cyan binaries is not available, or Python is not available")
}

simpact.set.simulation <- function(simulationName)
{
	check.available()

	r = pithon.call("simpactPythonInstance.setSimulationPrefix", simulationName, instance.name="simpact")
	invisible(r)
}

simpact.set.datadir <- function(dirName)
{
	check.available()

	r = pithon.call("simpactPythonInstance.setSimpactDataDirectory", dirName, instance.name="simpact")
	invisible(r)
}

simpact.run.direct <- function(configFile, outputFile = NULL, release = TRUE, slowalg = FALSE, parallel = FALSE, seed = -1, destDir=NULL)
{
	check.available()

	if (!is.null(configFile))
		configFile <- configFile[[1]]
	if (!is.null(outputFile))
		outputFile <- outputFile[[1]]

	r = pithon.call("simpactPythonInstance.runDirect", configFile, parallel, !slowalg, release, outputFile, seed, destDir, instance.name="simpact")
	invisible(r)
}

simpact.run <- function(configParams, destDir, agedist = "${SIMPACT_DATA_DIR}sa_2003.csv", intervention = NULL, release = TRUE, slowalg = FALSE, parallel=FALSE, seed=-1, dryrun = FALSE, identifierFormat = "%T-%y-%m-%d-%H-%M-%S_%p_%r%r%r%r%r%r%r%r")
{
	check.available()

	r = pithon.call("simpactPythonInstance.run", configParams, destDir, agedist, parallel, !slowalg, release, seed, intervention, dryrun, identifierFormat, instance.name="simpact")
}

simpact.getconfig <- function(configParams, show = FALSE)
{
	check.available()

	r = pithon.call("simpactPythonInstance.getConfiguration", configParams, show, instance.name="simpact")

	cfg <- list()
	num <- length(r)
	for ( i in 1:num )
	{
		name <- r[[i]][[2]]
		# Warning: if val is NULL, this entry will be removed from the list
		val <- r[[i]][[3]]
		cfg[name] <- val
	}

	return(cfg)
}

simpact.showconfig <- function(configParams)
{
	check.available()

	r = simpact.getconfig(configParams, show = TRUE)
	invisible(r)
}


