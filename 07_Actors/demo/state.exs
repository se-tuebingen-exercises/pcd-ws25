
defmodule VendingMachine do
  def idle do
    receive do
      :coin ->
        IO.puts("Coin inserted")
        ready()
    end
  end

  def ready do
    receive do
      :select ->
        IO.puts("Dispensing item...")
        dispensing()
      :refund ->
        IO.puts("Refunding coin")
        idle()
    end
  end

  def dispensing do
    receive do
      :success ->
        IO.puts("Item dispensed")
        idle()
    end
  end
end

# pid = spawn(fn -> VendingMachine.idle() end)

# send(pid, :coin)
# send(pid, :select)
# send(pid, :success)
# send(pid, :coin)
# send(pid, :refund)

