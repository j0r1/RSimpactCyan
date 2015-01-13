\name{simpact.available}
\alias{simpact.available}
\title{simpact.available}
\description{
	Checks if SimpactCyan simulations can run using these R bindings.
}
\usage{
simpact.available()
}
\details{
	Checks if SimpactCyan simulations can run using these R bindings. If not, either
	the SimpactCyan binary package was not installed (needs to be installed separately
	from the R bindings), or Python could not be started using the rPithon package.
}
\value{
 	\code{TRUE} or \code{FALSE} depending on whether SimpactCyan binaries can be 
	executed using these R bindings.
}

\examples{
	if (simpact.available()) {
		print("SimpactCyan binaries are found and can be used")
	} else {
		print("Either the SimpactCyan binaries could not be found, or rPithon can not use Python")
	}
}

\keyword{manip}

