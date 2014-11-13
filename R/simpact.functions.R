simpact.run.direct <- function(configFile, outputfile = NULL, release = TRUE, slowalg = FALSE, parallel = FALSE, seed = -1, destdir=NULL)
{
	r = simpact.python.call("simpactPythonInstance.runDirect", configFile, parallel, !slowalg, release, outputfile, seed, destdir)
	invisible(r)
}

simpact.run <- function(configParams, destDir, agedist = simpact.sa2003, intervention = NULL, release = TRUE, slowalg = FALSE, parallel=FALSE, seed=-1, dryrun = FALSE)
{
	r = simpact.python.call("simpactPythonInstance.run", configParams, destDir, agedist, parallel, !slowalg, release, seed, intervention, dryrun)
}

simpact.getconfig <- function(configParams, show = FALSE)
{
	r = simpact.python.call("simpactPythonInstance.getConfiguration", configParams, show)

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
}


