Rcpp::loadModule("statsdmodule", TRUE)

library(R6)

#' Main entrypoint Statsd client class
#' 
#' Exposes statsd-formatted metrics from R. For more info on statsd, please consult: \href{https://github.com/statsd/statsd/blob/master/docs/metric_types.md}{official statsd Github wiki.}
#' 
#' @section Common parameters:
#' \describe{
#' \item{\code{sample_rate}}{All methods support \code{sample_rate}: setting it to a value in \code{(0, 1]} to send only a fraction of measurements.}
#' }
#' @import Rcpp
#' @useDynLib rstatsd
#' @section Methods:
#' \describe{
#'   \item{\code{$new(host, port, ns)}}{Create new client instance, sending all packets to \code{host} on port \code{port}. Optionally prefix the metric names with \code{ns}}
#'   \item{\code{$count(key, value, sample_rate)}}{Adds \code{value} to the \code{key} bucket. }
#'   \item{\code{$inc(key, sample_rate)}}{Increments \code{key} bucket. }
#'   \item{\code{$dec(key, sample_rate)}}{Decrements \code{key} bucket. }
#'   \item{\code{$gauge(key, value, sample_rate)}}{Set \code{key} gauge value to \code{value}. }
#'   \item{\code{$timing(value, value, sample_rate)}}{Send timing measurement \code{value} to \code{key} bucket. Note: \code{value} should be provided in milliseconds.}
#'   \item{\code{$timed.call(key, expr, sample_rate)}}{Perform timed call of \code{expr} and send the duration to \code{key} bucket. Returns: result of \code{expr}}
#'   \item{\code{$gauged.call(value, expr, sample_rate)}}{Perform gauged call of \code{expr} and send the result to \code{key} bucket. Returns result of \code{expr}}
#'   }
#' @export
#' @importFrom R6 R6Class
#' @name Statsd
#' @examples
#' client <- Statsd$new("127.0.0.1", 31337, "prefix.")
#' 
#' client$gauge()
#' client$timed.call("timer_name", { print("Timed expression."); Sys.sleep(1); 42 })
#' client$gauged.call("gauge_name", { print("Gauged expression."); 42 })

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
    inc = function(key, sample_rate = 1) {
      invisible(self$count(key, 1, sample_rate))
    },
    dec = function(key, sample_rate = 1) {
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
