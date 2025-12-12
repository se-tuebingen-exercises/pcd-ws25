
defmodule Fairness do

  def worker() do
    Enum.each(1..1_000_000_000, fn _ ->
      :math.sqrt(12345)
    end)
  end

  def printer() do
    receive do
      message ->
        IO.puts(message <> "!")
        printer()
    end
  end
end

for i <- 1..50 do
    spawn(fn -> Fairness.worker() end)
end

pid = spawn(fn -> Fairness.printer() end)

Process.register(pid, :printer)

