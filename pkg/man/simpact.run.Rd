\name{simpact.run}
\alias{simpact.run}
\title{simpact.run}
\description{
	Perform a simulation using the SimpactCyan binaries.
}
\usage{
 	simpact.run(configParams, destDir, agedist = simpact.sa2003, intervention = NULL, release = TRUE, slowalg = FALSE, parallel=FALSE, seed=-1, dryrun = FALSE)
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
		       a 'Percent.Female' column.}
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
}
\details{
	TODO

	population.agedistfile
	logsystem.filename.events
	logsystem.filename.persons
	logsystem.filename.relations
	logsystem.filename.treatments
	intervention.enabled
	intervention.times
	intervention.fileids
	intervention.baseconfigname
}
\value{
 	TODO
}

\examples{
}

\keyword{manip}

