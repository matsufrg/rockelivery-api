defmodule Rockelivery.Orders.TotalPrice do
  alias Rockelivery.Item

  def call(items) do
    Enum.reduce(items, Decimal.new("0.00"), &sum_values/2)
  end

  def sum_values(%Item{price: price}, acc), do: Decimal.add(price, acc)
end
