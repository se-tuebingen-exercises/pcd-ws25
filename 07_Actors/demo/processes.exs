
spawn(fn ->
  IO.write("A1 ")
  IO.write("A2 ")
end)

spawn(fn ->
  IO.write("B1 ")
  IO.write("B2 ")
end)

spawn(fn ->
  IO.write("C1 ")
  IO.write("C2 ")
end)

Process.sleep(100)
IO.puts("")

