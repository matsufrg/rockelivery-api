defmodule Rockelivery.Users.CreateTest do
  use Rockelivery.DataCase
  import Rockelivery.Factory

  alias Rockelivery.{Error, User}
  alias Rockelivery.Users.Create

  describe "call/1" do
    test "when giving params, create an user" do
      params = build(:user_params)

      response = Create.call(params)

      assert {:ok, %User{id: _id, name: "Roberto"}} = response
    end

    test "when the giving params has an error, returns an error" do
      params =
        build(:user_params, %{
          age: 15,
          cep: "123",
          cpf: "123",
          email: "roberto.marques",
          password: "123"
        })

      response = Create.call(params)

      expected_response = %{
        age: ["must be greater than or equal to 18"],
        cep: ["should be 8 character(s)"],
        cpf: ["should be 11 character(s)"],
        email: ["has invalid format"],
        password: ["should be 6 character(s)"]
      }

      assert {:error, %Error{result: changeset}} = response
      assert errors_on(changeset) == expected_response
    end
  end
end
