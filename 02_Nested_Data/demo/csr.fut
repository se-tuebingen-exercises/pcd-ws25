
def multiply_coo [k] [m] (rows: [k]i64) (columns: [k]i64) (values: [k]f64) (vector: [m]f64) (n: i64) : [n]f64 =
  let products = map2 (\c v -> v * vector[c]) columns values
  in reduce_by_index (replicate n 0.0) (+) 0.0 rows products

def compress [k] (rows: [k]i64) (n: i64) : [n]i64 =
  let histogram = reduce_by_index (replicate n 0) (+) 0 rows (replicate k 1)
  in scan (+) 0 histogram

def uncompress [n] (offsets: [n]i64) (k: i64) : [k]i64 =
  let flags = reduce_by_index (replicate k 0) (+) 0 offsets (replicate n 1)
  in map (\i -> i - 1) (scan (+) 0 flags)

def multiply_csr [k] [n] [m] (offsets: [n]i64) (columns: [k]i64) (values: [k]f64) (vector: [m]f64) : [n]f64 =
  multiply_coo (uncompress offsets k) columns values vector n

def main : []f64 =
  let offsets = [0, 2, 3, 5]
  let columns = [0, 2, 1, 0, 2, 3]
  let values  = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
  let vector  = [1.0, 2.0, 3.0, 4.0]

  in multiply_csr offsets columns values vector

