\name{simpact.getconfig}
\alias{simpact.getconfig}
\alias{simpact.showconfig}
\title{simpact.getconfig and simpact.showconfig}
\description{
	Shows or retrieves the configuration file that will be used when running
	one the the SimpactCyan binaries, based on the parameters specified as
	a parameter.
}
\usage{
  simpact.getconfig(configParams, show = FALSE)
  simpact.showconfig(configParams)
}
\arguments{
	\item{configParams}{A list containing key/value pairs which specifies configuration
	                    parameters to be set to a non-default value. Set to NULL to
			    view all the default values.}
	\item{show}{If \code{TRUE}, the on-screen output of \code{simpact.getconfig} will
	            be the same as that of \code{simpact.showconfig}}
}
\details{
	The SimpactCyan programs use a configuration file to determine what scenario to
	run. Such a configuration file is a simple text file, containing keys (a short text
	string) describing what property should be set, and values (numbers, file names, ...,
	all written down as text) describing what the property should be set to.

	These functions take a list containing key/value pairs as input, and output the
	full configuration file that's obtained when these are combined with the defaults
	of the program. The \code{simpact.showconfig} function does not return anything,
	it merely shows the full configuration file based on the \code{configParams} list
	that's passed as input. The \code{simpact.getconfig} function also returns the
	full configuration as a list.

	The main use of these functions is to be able to see which properties can be set
	to which values. The generated config file that's shown on screen will also contain
	some comments describing what each parameter is for.
}
\value{
 	\code{simpact.showconfig} returns a complete list of key/value pairs, that's
	obtained when combining the input in \code{configParams} with the default values
	for the program.
}

\examples{
	if (simpact.available()) {
		# Just show all the defaults
		simpact.showconfig(NULL)

		# Set number of men and women
		cfg <- list()
		cfg["population.nummen"] <- 1000
		cfg["population.numwomen"] <- 1000
		
		cfgFull <- simpact.getconfig(cfg)

		print("Number of men:") # We set this to 1000
		print(cfgFull["population.nummen"])

		print("Simulation time:") # This was not set by us
		print(cfgFull["population.simtime"])
	}
}

\keyword{manip}

