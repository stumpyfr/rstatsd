Rcpp::loadModule("statsdmodule", TRUE)

library(R6)

Statsd <- R6Class(
  "Statsd",
  public = list(
    initialize = function(host = "127.0.0.1",
                          port = 8125,
                          ns = "") {
      private$statsd_client <- new(rstatsd::Statsd, host, port, ns)
    },
    count = function(key, value, sample_rate = 1) {
      invisible(private$statsd_client$send(key, value, "c", sample_rate))
    },
    inc = function(key, value, sample_rate = 1) {
      invisible(self$count(key, 1, sample_rate))
    },
    dec = function(key, value, sample_rate = 1) {
      invisible(self$count(key,-1, sample_rate))
    },
    gauge = function(key, value, sample_rate = 1) {
      invisible(private$statsd_client$send(key, value, "g", sample_rate))
    },
    timing = function(key, value, sample_rate = 1) {
      invisible(private$statsd_client$send(key, value, "ms", sample_rate))
    }
  ),
  private = list(statsd_client = NULL)
)
