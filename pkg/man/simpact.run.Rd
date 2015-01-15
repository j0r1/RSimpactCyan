\name{simpact.run}
\alias{simpact.run}
\title{simpact.run}
\description{
	Perform a simulation using the SimpactCyan binaries.
}
\usage{
simpact.run(configParams, destDir, agedist = "${SIMPACT_DATA_DIR}sa_2003.csv", 
            intervention = NULL, release = TRUE, slowalg = FALSE, 
            parallel = FALSE, seed = -1, dryrun = FALSE,
            identifierFormat = "\%T-\%y-\%m-\%d-\%H-\%M-\%S_\%p_\%r\%r\%r\%r\%r\%r\%r\%r-")
}
\arguments{
	\item{configParams}{A list containing key/value pairs which specifies configuration
	                    parameters to be set to a non-default value. Set to NULL to use
			    only the default values.}
	\item{destDir}{The full configuration file created based on the \code{configParams}
	               list will be stored here, as well as various output logs produced
		       by the simulation.}
	\item{agedist}{The age distribution, either specified as a CSV filename or as an R
	               table. This should have an 'Age' column, a 'Percent.Male' column and
		       a 'Percent.Female' column. The default is the file \code{sa_2003.csv}
		       that comes with the SimpactCyan binary package.}
	\item{intervention}{The SimpactCyan simulations support an 'intervention event',
	                    which can modify parameters that were previously read from the
			    config file. List is a each intervention itself is a list that
			    contains key/value pairs just like \code{configParams}. One
			    extra key that is used, is 'time', specifying when the intervention
			    should take place. Because multiple intervention eventss can be
			    present, this \code{intervention} parameter is a list of such
			    lists.}
	\item{release}{If \code{TRUE} (the default), the program will run without additional 
	               debugging checks. It is a good idea to set this to \code{FALSE} from
		       time to time, perhaps for a shorter simulation or one with a smaller
		       population size, to verify that all code being executed is working
		       as expected. For the same seed value, the two versions should produce
		       the same output.}
	\item{slowalg}{By default, this is set to \code{FALSE} and a population based method
	               modified Next Reaction Method (mNRM) algorithm is used to calculate
		       the event times. If set to \code{TRUE}, a more basic mNRM algorithm
		       is used, which recalculates the event fire times at each step. This
		       is much more slow, but should give the same results as the population
		       based approach when the same seed is used.}
	\item{parallel}{If set to \code{FALSE}, a single processor version of the SimpactCyan
	                program will be executed. If your computer has more cores, depending
			on the population size and the number of events in the system, the
			simulation may run faster when all available processors are used. To
			do so, set this flag to \code{TRUE}.}
	\item{seed}{If this value is negative, the random number generator will be initialized
	            randomly. To reproduce results, it can be helpful to explicitly set the
		    seed value used by the random number generator here.}
	\item{dryrun}{This is \code{FALSE} by default, and the SimpactCyan program will be
	              started for this value. If set to \code{TRUE}, the config files will
		      be prepared in the specified directory, but the program itself will
		      not be executed. Using this option allows you to prepare configuration
		      files in advance, which can even be executed by a SimpactCyan program
		      on a different computer.}
	\item{identifierFormat}{The filenames created by the SimpactCyan simulation will
	                        start with a certain identifier. The format of this identifier
				is specified by this parameter. See the details for more
				information.}
}
\details{
	Based on the specified configuration in \code{configParams}, a full configuration
	file for the SimpactCyan program will be created. The \code{configParams} parameter
	should be a list with key/value pairs that will be combined with the program
	defaults when creating this config file. To verify that this parameter is correct
	and to view the full configuration file that will be used, the \code{\link{simpact.showconfig}}
	function can be used. This will also give an overview of all parameters which
	can be configured.

	A number of settings will be overwritten based on the other parameters present in
	this \code{simpact.run} function call. It is allowed to set these in your
	\code{configParams}, but the values that you specified will not be used.
	These configuration parameter keys currently are:

	\itemize{
		\item \code{population.agedistfile}: this will be overwritten depending
		      on what you specified in the \code{agedist} parameter.
		\item \code{logsystem.filename.events}, \code{logsystem.filename.persons},
		      \code{logsystem.filename.relations} and \code{logsystem.filename.treatments}: 
		      these will be set to the log files produced by the simulation.
		\item \code{intervention.enabled}, \code{intervention.times}, \code{intervention.fileids},
		      and \code{intervention.baseconfigname}: these will be set based on the
		      \code{intervention} parameter you passed to this function.
	}

	The default parameter for \code{agedist} is \code{"${SIMPACT_DATA_DIR}sa_2003.csv"},
	meaning that the file \code{sa_2003.csv} will be used that is present as data in the
	installed SimpactCyan binary package. In general, \code{"${SIMPACT_DATA_DIR}"} will
	be replaced by the data directory of the SimpactCyan binary package.

	Files that are created by the simulation will all start with the same identifier,
	which will also be mentioned in the data structure returned by this function. The
	\code{identifierFormat} parameter specifies what this identifier should be. Special
	properties start with a percent (\%) sign, other things are just copied. An overview
	of these special properties:
	\itemize{
		\item \code{\%T}: will expand to the simulation type, e.g. \code{simpact-cyan}
		                  or \code{maxart}
		\item \code{\%y}: the current year 
		\item \code{\%m}: the current month (number)
		\item \code{\%d}: the current day of the month
		\item \code{\%H}: the current hour
		\item \code{\%M}: the current minute
		\item \code{\%S}: the current second
		\item \code{\%p}: the process ID of the process starting the simulation
		\item \code{\%r}: a random character
	}

	The default identifier format \code{\%T-\%y-\%m-\%d-\%H-\%M-\%S_\%p_\%r\%r\%r\%r\%r\%r\%r\%r-}
	would lead to an identifier like \code{simpact-cyan-2015-01-15-08-28-10_2425_q85z7m1G-}.
}
\value{
 	Returns a data structure containing information about the files
	used by the simulation, as well as the log files that are produced.
	Calling the returnvalue \code{ret}, this data structure contains
	the following items:
	\itemize{
		\item \code{ret["configfile"]}: This is the complete
		      config file used by the simulation.
		\item \code{ret["agedistfile"]}: The path to the CSV file
		      containing the age distribution which was used in
		      initializing the population.
		\item \code{ret["outputfile"]}: Full path to the output
		      that the program normally writes to the screen (and
		      is shown on screen as well). This provides very
		      useful information, like the version number, the
		      type of run done (parallel, with debug information,
		      slow algorithm version, ...) as well as the seed
		      used for the random number generator.
		\item \code{ret["logevents"]}: Full path to a log file describing
		      which events took place at which time. This is written as
		      a file with comma separated values, but depending on the
		      event, the number of columns used can change.
		\item \code{ret["logpersons"]}: Full path to the CSV file containing information
		      about the persons in the simulation.
		\item \code{ret["logrelations"]}: Full path to the CSV file containing information
		      about which relationships were formed in the simulation.
		\item \code{ret["logtreatments"]}: Full path to the CSV file containing information
		      about HIV treatments that took place.
		\item \code{ret["id"]}: A prefix that's used in all files used
		      in this simulation.
	}

	If the \code{dryrun} parameter was set to \code{TRUE}, the log files 
	will not yet exist. When the simulation is actually executed however, these 
	are the files in which log information will be written.
}

\examples{
	if (simpact.available()) {
		# Perform a run with all default parameters. Note that
		# tempdir() will only exist while the R session is running,
		# so do not use this for results that should be kept longer.
		r <- simpact.run(NULL, tempdir())

		# Use a config file
		cfg <- list()
		cfg["population.nummen"] <- 250
		cfg["population.numwomen"] <- 250
		r <- simpact.run(cfg, tempdir())

		# Read the person log file
		p <- read.csv(r["logpersons"])

		# Set some intervention events as well: we'll modify
		# a parameter of the hazard of formation (is 0.1)
		# by default
		iv1 <- list()
		iv1["time"] <- 5.0
		iv1["formation.hazard.agegap.baseline"] <- 2.3

		iv2 <- list()
		iv2["time"] <- 10.0
		iv2["formation.hazard.agegap.baseline"] <- 0.4

		# The actual parameter to the 'simpact.run' call is
		# a list of these lists
		interventions <- list(iv1, iv2)
		
		r <- simpact.run(cfg, tempdir(), intervention=interventions)
		r
	}
}

\keyword{manip}

