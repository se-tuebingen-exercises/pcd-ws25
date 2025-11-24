
def gather (xs: []f64) (is: []i32) : []f64 =
  map (\i -> xs[i]) is

entry main (xs: [4]f64) (is: [4]i32) : [4]f64 =
  gather xs is


