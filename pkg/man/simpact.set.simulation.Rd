\name{simpact.set.simulation}
\alias{simpact.set.simulation}
\title{simpact.set.simulation}
\description{
	Select which SimpactCyan simulation you want to run using
	these R bindings.
}
\usage{
	simpact.set.simulation(simulationName)
}
\arguments{
	\item{simulationName}{Name of the simulation.}
}
\details{
	This function selects which executables from the SimpactCyan
	binary package will be used for the other RSimpactCyan command
	(e.g. \code{\link{simpact.run}}). If this is not called explicitly,
	this corresponds to having set this to \code{simpact-cyan}.

	Important: this setting is not remembered when quitting R and
	restarting. If it was set to something else than the default, you'll
	need to call this function again in a new R session.

	Currently, the possible values are:
	\itemize{
		\item \code{simpact-cyan}: this is the default, and will select
		      the general SimpactCyan based simulation.
		\item \code{maxart}: if this is selected, the MaxART simulation
		      will be used instead.
	}
}
\value{
 	None.
}

\examples{
	if (simpact.available()) {
		simpact.set.simulation("maxart")
	}
}

\keyword{manip}

