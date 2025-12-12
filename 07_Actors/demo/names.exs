
IO.inspect(self())

pid = spawn(fn ->
  IO.puts("I am #{inspect(self())}")
end)

IO.puts("Spawned process: #{inspect(pid)}")

