
def prefix_sum [n] (xs: [n]f64) : [n]f64 =
  scan (+) 0 xs

entry main (xs: [4]f64) : [4]f64 =
  prefix_sum xs

