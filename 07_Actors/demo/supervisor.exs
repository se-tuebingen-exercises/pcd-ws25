
defmodule Worker do
  def start do
    Process.sleep(1000)
  end
end

defmodule Super do
  def start do
    Process.flag(:trap_exit, true)
    spawn_link(fn -> Worker.start() end)
    loop()
  end

  defp loop do
    receive do
      {:EXIT, pid, reason} ->
        IO.inspect({:EXIT, pid, reason})
        loop()
    end
  end
end

Super.start()

