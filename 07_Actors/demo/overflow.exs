
defmodule Worker do
  def loop do
    receive do
      :stop -> :ok
      {:data, _} -> loop()
    end
  end
end

pid = spawn(fn -> Worker.loop() end)

Enum.each(1..100000000, fn i ->
  send(pid, {:deta, i})
end)

