def scatter [n] (is: [n]i64) (vs: [n]f64) (m: i64) : []f64 =
  reduce_by_index (replicate m 0) (+) 0 is vs

entry main (is: [4]i64) (vs: [4]f64) : [4]f64 =
  scatter is vs 4
