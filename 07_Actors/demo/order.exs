
send(self(), {:b, 2})

receive do
  {:a, x} -> IO.puts("a: #{x}")
end

send(self(), {:a, 1})

receive do
  {:b, y} -> IO.puts("b: #{y}")
end

