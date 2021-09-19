defmodule Rockelivery.Item do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rockelivery.Order

  alias Ecto.Enum

  @primary_key {:id, :binary_id, autogenerate: true}

  @required_params [:category, :description, :photo, :price]

  @item_categories [:food, :desert, :drinks]

  @derive {Jason.Encoder, only: @required_params ++ [:id]}

  schema "items" do
    field :category, Enum, values: @item_categories
    field :description, :string
    field :photo, :string
    field :price, :decimal

    many_to_many :orders, Order, join_through: "orders_items"

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_length(:description, min: 6)
    |> validate_number(:price, greater_than: 0)
  end
end
