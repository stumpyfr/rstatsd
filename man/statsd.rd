\name{Statsd}
\Rdversion{1.1}
\docType{class}
\alias{Statsd-class}

\title{Class "Statsd"}
\description{
R StatsD client
}
\section{Methods}{
  \describe{
	  \item{config}{\code{signature(object = "Statsd")}: allow to change the configuration during runtime }
	  \item{inc}{\code{signature(object = "Statsd")}: inc increments a statsd count type }
	  \item{dec}{\code{signature(object = "Statsd")}: dec decrements a statsd count type }
	  \item{count}{\code{signature(object = "Statsd")}: count submits a stats count type }
	  \item{gauge}{\code{signature(object = "Statsd")}: gauge submits/updates a statsd gauge type }
	  \item{timing}{\code{signature(object = "Statsd")}: timing submits a statsd timing type }
	 }
}
\examples{
client <- new(rstatsd::Statsd, "localhost", 8125, "myproject.", TRUE)
client$count("http.post.200", 1, 1)
}
\keyword{classes}