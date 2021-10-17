defmodule Rockelivery.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rockelivery.Order

  alias Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @params [:age, :address, :cep, :cpf, :email, :password, :name, :city, :UF]
  @derive_params @params -- [:password]
  @required_params @params -- [:city, :UF, :password]
  @update_params @required_params -- [:password]

  @derive {Jason.Encoder, only: @derive_params ++ [:id]}

  schema "users" do
    field :age, :integer
    field :address, :string
    field :cep, :string
    field :cpf, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :name, :string
    field :city, :string
    field :UF, :string

    has_many :orders, Order

    timestamps()
  end

  def changeset(params) do
    %__MODULE__{}
    |> change(params, @required_params, @params)
  end

  def changeset(struct, params) do
    struct
    |> change(params, @update_params)
  end

  def build(changeset), do: apply_action(changeset, :create)

  def change(struct, params, field, cast_params \\ @update_params) do
    struct
    |> cast(params, cast_params)
    |> validate_required(field)
    |> validate_length(:password, is: 6)
    |> validate_length(:cep, is: 8)
    |> validate_length(:cpf, is: 11)
    |> validate_number(:age, greater_than_or_equal_to: 18)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint([:email])
    |> unique_constraint([:cpf])
    |> put_password_hash()
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Pbkdf2.add_hash(password))
  end

  defp put_password_hash(changeset), do: changeset
end
