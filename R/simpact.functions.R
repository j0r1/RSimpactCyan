simpact.set.simulation <- function(simulationName)
{
	r = pithon.call("simpactPythonInstance.setSimulationPrefix", simulationName, instance.name="simpact")
	invisible(r)
}

simpact.set.datadir <- function(dirName)
{
	r = pithon.call("simpactPythonInstance.setSimpactDataDirectory", dirName, instance.name="simpact")
	invisible(r)
}

simpact.run.direct <- function(configFile, outputFile = NULL, release = TRUE, slowalg = FALSE, parallel = FALSE, seed = -1, destDir=NULL)
{
	r = pithon.call("simpactPythonInstance.runDirect", configFile, parallel, !slowalg, release, outputFile, seed, destDir, instance.name="simpact")
	invisible(r)
}

simpact.run <- function(configParams, destDir, agedist = simpact.sa2003, intervention = NULL, release = TRUE, slowalg = FALSE, parallel=FALSE, seed=-1, dryrun = FALSE)
{
	r = pithon.call("simpactPythonInstance.run", configParams, destDir, agedist, parallel, !slowalg, release, seed, intervention, dryrun, instance.name="simpact")
}

simpact.getconfig <- function(configParams, show = FALSE)
{
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
	r = simpact.getconfig(configParams, show = TRUE)
	invisible(r)
}

