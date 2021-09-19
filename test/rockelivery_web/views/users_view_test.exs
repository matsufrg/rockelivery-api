defmodule RockeliveryWeb.UsersViewTest do
  use RockeliveryWeb.ConnCase, async: true

  import Phoenix.View
  import Rockelivery.Factory

  alias RockeliveryWeb.UsersView

  test "renders create.json" do
    user = build(:user)

    response = render(UsersView, "create.json", user: user)

    expected_response = %{
      message: "User created successfully",
      user: %Rockelivery.User{
        address: "Rua das Bananeiras",
        age: 27,
        cep: "12345678",
        cpf: "12345678900",
        email: "roberto.marques@impar.com.br",
        id: "95d0c007-5cd9-46be-84b6-143a84e5cc2e",
        inserted_at: nil,
        name: "Roberto",
        password: "123456",
        password_hash: nil,
        updated_at: nil
      }
    }

    assert response == expected_response
  end
end
