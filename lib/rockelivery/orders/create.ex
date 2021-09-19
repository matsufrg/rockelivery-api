defmodule Rockelivery.Orders.Create do
  import Ecto.Query
  alias Rockelivery.{Error, Item, Order, Repo}
  alias Rockelivery.Orders.ValidateAndMultiplyItems

  def call(%{"items" => items_params} = params) do
    items_ids = Enum.map(items_params, fn item -> item["id"] end)

    query = from item in Item, where: item.id in ^items_ids

    query
    |> Repo.all()
    |> ValidateAndMultiplyItems.call(items_ids, items_params)
    |> handle_items(params)
  end

  def handle_items({:error, result}, _params), do: Error.build(:bad_request, result)

  def handle_items({:ok, items}, params) do
    params
    |> Order.changeset(items)
    |> Repo.insert()
    |> handle_insert()
  end

  def handle_insert({:error, result}), do: Error.build(:bad_request, result)

  def handle_insert({:ok, %Order{}} = order), do: order
end
