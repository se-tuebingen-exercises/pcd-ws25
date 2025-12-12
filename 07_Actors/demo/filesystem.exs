

case File.read("input1.txt") do

  {:ok, content} ->
    upper = String.upcase(content)
    File.write("output.txt", upper)

  {:error, reason} ->
    IO.puts("Error: #{reason}")

end

