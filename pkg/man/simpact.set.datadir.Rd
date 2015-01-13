\name{simpact.set.datadir}
\alias{simpact.set.datadir}
\title{simpact.set.datadir}
\description{
	The RSimpactCyan module will try to figure out what the
	data directory is for the installed SimpactCyan binary
	package. If the correct directory could not be detected
	this way, you can set it manually using this command.
}
\usage{
 	simpact.set.datadir(dirName)
}
\arguments{
	\item{dirName}{The pull path of the directory in which
	               the data files (e.g. \code{sa_2003.csv})
		       from the SimpactCyan binaries are stored.
		       It is best to make sure that this path
		       ends with a slash ('/') or a backslash
		       ('\\'), depending on the operating system
		       you're using.}
}
\details{
	When the RSimpactCyan package is loaded, it will try
	to detect where the SimpactCyan binary package has stored
	its data files (e.g. \code{sa_2003.csv} or \code{hhohho_mask.tiff}).
	This directory is used to replace \code{${SIMPACT_DATA_DIR}}
	when reading the configuration file, for example for specifying
	the default age distribution in \code{\link{simpact.run}}.
	If, for some reason, this path could not be found, or an incorrect
	path was used, it can be set manually using this function.
}
\value{
 	None.
}

\examples{
	\dontrun{simpact.set.datadir("/path/to/alternate/data/directory/")}
}

\keyword{manip}

