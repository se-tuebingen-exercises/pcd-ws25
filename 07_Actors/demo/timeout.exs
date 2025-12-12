
defmodule Fork do
  def start do
    receive do
      {:acquire, pid} ->
        IO.puts("acquired")
        send(pid, {:granted, self()})
        receive do
          {:release, ^pid} ->
            IO.puts("released")
            start()
        end
    end
  end
end

defmodule Philosopher do
  def start(name, left, right) do
    send(left, {:acquire, self()})
    receive do
      {:granted, ^left} ->
        send(right, {:acquire, self()})
        receive do
          {:granted, ^right} ->
            IO.puts("#{name} eating")
            send(left, {:release, self()})
            send(right, {:release, self()})
        after
          1000 ->
            IO.puts("timeout 2")
            send(left, {:release, self()})
            send(right, {:release, self()})
            start(name, left, right)
        end
    after
      1000 ->
        send(left, {:release, self()})
        IO.puts("timeout 1")
        start(name, left, right)
    end
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

