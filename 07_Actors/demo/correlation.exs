
defmodule Calculator do
  def loop do
    receive do
      {caller, ref, input1, input2} ->
        Process.sleep(:rand.uniform(20))
        send(caller, {ref, input1 + input2})
        loop()
    end
  end
end

calculator1 = spawn(fn -> Calculator.loop() end)
calculator2 = spawn(fn -> Calculator.loop() end)

ref1 = make_ref()
ref2 = make_ref()

send(calculator1, {self(), ref1, 5, 3})
send(calculator2, {self(), ref2, 10, 20})

receive do
  {^ref1, result} -> IO.puts("5 + 3 = #{result}")
end
receive do
  {^ref2, result} -> IO.puts("10 + 20 = #{result}")
end

