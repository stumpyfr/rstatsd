Rcpp::loadModule("statsdmodule", TRUE)

library(R6)

Statsd <- R6Class(
  "Statsd",
  public = list(
    initialize = function(host = "127.0.0.1",
                          port = 8125,
                          ns = "") {
      private$statsd_client <- new(Statsd_Impl, host, port, ns)
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
    },
    timed.call = function(key, expr, sample_rate = 1) {
      stopifnot(is.character(key))
      pre <- Sys.time()
      force(expr)
      post <- Sys.time()
      formatted_difftime <- as.numeric(difftime(post, pre, units="secs")) * 1000
      self$timing(key, formatted_difftime, sample_rate)
      expr
    },
    gauged.call = function(key, expr, sample_rate = 1) {
      stopifnot(is.character(key))
      result <- force(expr)
      stopifnot(is.numeric(result))
      self$gauge(key, result, sample_rate)
      result
    }
  ),
  private = list(statsd_client = NULL)
)
