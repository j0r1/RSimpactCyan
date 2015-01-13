\name{simpact.run.direct}
\alias{simpact.run.direct}
\title{simpact.run.direct}
\description{
	This allows you to run the SimpactCyan simulation using a config file
	that is already completely prepared, for example by setting the
	\code{dryrun} parameter in \code{\link{simpact.run}}.
}
\usage{
simpact.run.direct(configFile, outputFile = NULL, release = TRUE, slowalg = FALSE,
                   parallel = FALSE, seed = -1, destDir = NULL)
}
\arguments{
	\item{configFile}{Full path to the configuration file.}
	\item{outputFile}{If set to \code{NULL}, the output of the program
	                  (containing which seed was used, which algorithm
			  was used, ...) will be shown on screen, but not
			  saved to a file. To write this to a file as well,
			  the path to that file can be specified here.}
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
	\item{destDir}{By default, the SimpactCyan program will be run in the directory where
	               the config file is located. This also means that filenames which
		       are specified in the config file (e.g. for the log files) that do not
		       contain a full path, will be interpreted as being located in this
		       directory of the config file. If you want to override this behaviour
		       and make sure that the simulation is started from another directory,
		       this directory name can be specified here.}
}
\details{
	TODO
}
\value{
 	None.
}

\examples{
}

\keyword{manip}

