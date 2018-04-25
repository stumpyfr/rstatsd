# StatsD client (R)

## Introduction

Go Client library for [StatsD](https://github.com/etsy/statsd/). Contains a direct only, buffered version in todo

***Only working on Linux and Mac for now***, next step would be Windows support (feel free to create a PR!)

## Installation

    devtools::install_github("stumpyfr/rstatsd")
    
## Supported event types

* `Increment` - Count occurrences per second/minute of a specific event
* `Decrement` - Count occurrences per second/minute of a specific event
* `Count` - Continously increasing value, e.g. read operations since boot
* `Timing` - To track a duration event
* `Gauge` Gauges are a constant data type. They are not subject to averaging, and they don’t change unless you change them. That is, once you set a gauge value, it will be a flat line on the graph until you change it again

## Sample usage

to count each http 200 return code on post event, the last parameters allow you to set the sample rate

```
library("rstatsd")
client <- new(rstatsd::Statsd, "localhost", 8125, "myproject.")
client$count("http.post.200", 1, 1)
```
