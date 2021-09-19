defmodule Rockelivery.Orders.ValidateAndMultiplyItems do
  def call(items, items_ids, items_params) do
    items_map = Map.new(items, fn item -> {item.id, item} end)

    items_ids
    |> Enum.map(fn id -> {id, Map.get(items_map, id)} end)
    |> Enum.any?(fn {_id, value} -> is_nil(value) end)
    |> multiply_items(items_map, items_params)
  end

  def multiply_items(false, items, items_params) do
    result =
      Enum.reduce(items_params, [], fn %{"id" => id, "quantity" => quantity}, acc ->
        item = Map.get(items, id)

        acc ++ List.duplicate(item, quantity)
      end)

    {:ok, result}
  end

  def multiply_items(true, _items, _items_map),
    do: {:error, result: "Invalid Item Ids"}
end
