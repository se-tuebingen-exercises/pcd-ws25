
def multiply_ell [l] [n] [m] (columns: [n][l]i64) (values: [n][l]f64) (vector: [m]f64) : [n]f64 =
  map2 (\cs vs -> reduce (+) 0.0 (map2 (\c v -> v * vector[c]) cs vs)) columns values

def from_coo [k] [n] (rows: [k]i64) (columns: [k]i64) (values: [k]f64) (m : i64) (l : i64) : ([n][l]i64,[n][l]f64) =
  let counts = reduce_by_index (replicate m 0) (+) 0 rows (replicate k 1)
  let offsets = scan (+) 0 counts
  let flags = reduce_by_index (replicate k 0) (+) 0 offsets (replicate m 1)
  let indices = segmented_scan_add (map (>0) flags) (replicate k 1)
  let positions = zip rows (map (\i -> i - 1) indices)
  let ell_columns = scatter_2d (replicate n (replicate l 0)) positions columns
  let ell_values = scatter_2d (replicate n (replicate l 0.0)) positions values
  in (ell_columns, ell_values)

def main : []f64 =
  let columns = [[0, 2],[1, 0],[0, 2],[3, 0]]
  let values  = [[1.0, 2.0],[3.0, 0.0],[4.0, 5.0],[6.0, 0.0]]
  let vector = [1.0, 2.0, 3.0, 4.0]

  in multiply_ell columns values vector

