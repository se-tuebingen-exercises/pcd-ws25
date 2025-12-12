
defmodule Counter do
  def loop(count) do
    receive do
      :increment ->
        loop(count + 1)
      :display ->
        IO.puts("Count: #{count}")
        loop(count)
    end
  end
end

pid = spawn(fn -> Counter.loop(0) end)

spawn(fn -> send(pid, :increment) end)
spawn(fn -> send(pid, :increment) end)

Process.sleep(100)

send(pid, :display)

