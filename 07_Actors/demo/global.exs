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

:global.register_name(:printer, pid)

IO.inspect(:global.whereis_name(:printer))

printer_pid = :global.whereis_name(:printer)

send(printer_pid, "hello")

