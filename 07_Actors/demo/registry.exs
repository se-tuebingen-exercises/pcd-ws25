
defmodule Printer do
  def loop do
    receive do
      message ->
        IO.puts(message)
        loop()
    end
  end
end

pid = spawn(fn -> Printer.loop() end)

Process.register(pid, :printer)
IO.inspect(Process.whereis(:printer))
send(:printer, "hello")

