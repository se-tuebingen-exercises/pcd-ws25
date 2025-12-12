
defmodule Calculator do
  def loop do
    receive do
      {caller, input1, input2} ->
        Process.sleep(:rand.uniform(20))
        send(caller, input1 + input2)
        loop()
    end
  end
end

calculator1 = spawn(fn -> Calculator.loop() end)
calculator2 = spawn(fn -> Calculator.loop() end)

send(calculator1, {self(), 5, 3})
send(calculator2, {self(), 10, 20})

receive do
  result -> IO.puts("5 + 3 = #{result}")
end
receive do
  result -> IO.puts("10 + 20 = #{result}")
end

