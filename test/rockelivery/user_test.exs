defmodule Rockelivery.UserTest do
  use Rockelivery.DataCase, async: true

  import Rockelivery.Factory

  alias Ecto.Changeset
  alias Rockelivery.User

  describe "changeset/2" do
    test "when all params are valid, returns a valid changeset" do
      user_params = build(:user_params)

      response = User.changeset(user_params)

      assert %Changeset{changes: %{name: "Roberto"}, valid?: true} = response
    end

    test "when updating a user, returns a valid changeset with the given changes" do
      user_params = build(:user_params)

      response =
        user_params
        |> User.changeset()
        |> User.changeset(%{name: "Roberto Pereira"})

      assert %Changeset{changes: %{name: "Roberto Pereira"}, valid?: true} = response
    end

    test "when there are errors, returns an invalid changeset" do
      user_params =
        build(:user_params, %{
          age: 15,
          cep: "123",
          cpf: "123",
          email: "roberto.marques",
          password: "123"
        })

      response =
        user_params
        |> User.changeset()

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        cep: ["should be 8 character(s)"],
        cpf: ["should be 11 character(s)"],
        email: ["has invalid format"],
        password: ["should be 6 character(s)"]
      }

      assert errors_on(response) == expected_response
    end
  end
end
