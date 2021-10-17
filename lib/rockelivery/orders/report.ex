defmodule Rockelivery.Orders.Report do
  import Ecto.Query
  alias Rockelivery.{Item, Repo, Order}
  alias Rockelivery.Orders.TotalPrice

  @max_rows 500

  def create(filename \\ "report.csv") do
    query = from order in Order, order_by: order.user_id

    {:ok, order_items} = Repo.transaction(fn ->
      query
      |> Repo.all()
      |> Stream.chunk_every(@max_rows)
      |> Stream.flat_map(fn x -> Repo.preload(x, :items) end)
      |> Enum.map(&parse_line/1)
    end)

    File.write(filename, order_items)
  end

  def parse_line(%Order{items: items, user_id: user_id, payment_method: payment_method}) do
    total_price = TotalPrice.call(items)

    items_string = Enum.map(items, &items_string/1)

    "#{user_id},#{payment_method},#{items_string}#{total_price}\n"
  end

  def items_string(%Item{category: category, description: description, price: price}) do
    "#{category},#{description},#{price},"
  end
end
