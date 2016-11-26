\name{simpact.set.exedir}
\alias{simpact.set.exedir}
\title{simpact.set.exedir}
\description{
	The RSimpactCyan module will try to figure out what the
	executable directory is for the installed SimpactCyan binary
	package. If the correct directory could not be detected
	this way, you can set it manually using this command.
}
\usage{
 	simpact.set.exedir(dirName)
}
\arguments{
	\item{dirName}{The pull path of the directory in which
	               the SimpactCyan executable files are stored.}
}
\details{
	When the RSimpactCyan package is first used, it will try
	to detect where the SimpactCyan binary package has stored
	its executable files. If, for some reason, this path could not 
	be found, or an incorrect path was used, it can be set manually 
	using this function.
}
\value{
 	None.
}

\examples{
	\dontrun{simpact.set.exedir("/path/to/alternate/executable/directory/")}
}

\keyword{manip}

