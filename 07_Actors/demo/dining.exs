
defmodule Fork do
  def start do
    receive do
      {:acquire, pid} ->
        send(pid, {:granted, self()})
        receive do
          :release -> start()
        end
    end
  end
end

defmodule Philosopher do
  def start(name, left, right) do

    send(left, {:acquire, self()})
    receive do {:granted, ^left} -> :ok end

    send(right, {:acquire, self()})
    receive do {:granted, ^right} -> :ok end

    IO.puts("#{name} eating")

    send(left, :release)
    send(right, :release)
  end
end

fork0 = spawn(Fork, :start, [])
fork1 = spawn(Fork, :start, [])
fork2 = spawn(Fork, :start, [])
fork3 = spawn(Fork, :start, [])
fork4 = spawn(Fork, :start, [])

spawn(fn -> Philosopher.start("0", fork0, fork1) end)
spawn(fn -> Philosopher.start("1", fork1, fork2) end)
spawn(fn -> Philosopher.start("2", fork2, fork3) end)
spawn(fn -> Philosopher.start("3", fork3, fork4) end)
spawn(fn -> Philosopher.start("4", fork4, fork0) end)

