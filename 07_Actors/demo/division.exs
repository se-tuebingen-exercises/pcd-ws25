
defmodule Worker do
  def loop do
    receive do
      {:divide, from, dividend, divisor} ->
        send(from, div(dividend, divisor))
        loop()
    end
  end
end

defmodule Super do
  def start do
    Process.flag(:trap_exit, true)
    worker = spawn_link(fn -> Worker.loop() end)
    loop(worker)
  end

  defp loop(worker) do
    receive do

      {:EXIT, _pid, reason} ->
        IO.puts("Worker failed, restarting...")
        new_worker = spawn_link(fn -> Worker.loop() end)
        loop(new_worker)

      other ->
        send(worker, other)
        loop(worker)

    end
  end
end

defmodule Printer do
  def start do
    receive do
      result ->
        IO.inspect(result)
        start()
    end
  end
end

# supervisor = spawn(fn -> Super.start() end)
# printer = spawn(fn -> Printer.start() end)

# send(supervisor, {:divide, printer, 10, 2})
# send(supervisor, {:divide, printer, 10, 0})
# send(supervisor, {:divide, printer, 10, 2})


