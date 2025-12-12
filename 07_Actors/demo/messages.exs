
pid = spawn(fn ->
  receive do
    message -> IO.puts(message)
  end
end)

send(pid, "world")

send(self(), "hello1")
send(self(), "hello2")

receive do
  message -> IO.puts(message)
end

receive do
  message -> IO.puts(message)
end

receive do
  message -> IO.puts(message)
end

