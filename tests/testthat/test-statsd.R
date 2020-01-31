

test_that("client is instantiable and performs statsd calls", {
  client <- Statsd$new("127.0.0.1", 31337, "prefix.")
  expect_equal(client$timed.call("timer_name", {
    print("Printing from timed expression.")
    Sys.sleep(1)
    5
  }), 5)
  for (i in seq(1, 3)) {
    expect_equal(client$gauged.call("gauge_name", {
      print("Printing from gauged expression.")
      Sys.sleep(1)
      i
    }), i)
  }
})