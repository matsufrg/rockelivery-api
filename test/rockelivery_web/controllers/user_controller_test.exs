defmodule RockeliveryWeb.UserControllerTest do
  use RockeliveryWeb.ConnCase

  import Rockelivery.Factory

  describe "create/2" do
    test "when all params are valid, creates an user", %{conn: conn} do
      params = %{
        "age" => 27,
        "address" => "Rua das Bananeiras",
        "cep" => "12345678",
        "cpf" => "12345678900",
        "email" => "roberto.marques@impar.com.br",
        "password" => "123456",
        "name" => "Roberto"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:created)

      assert %{
               "message" => "User created successfully",
               "user" => %{
                 "address" => "Rua das Bananeiras",
                 "age" => 27,
                 "cpf" => "12345678900",
                 "email" => "roberto.marques@impar.com.br",
                 "id" => _id,
                 "name" => "Roberto"
               }
             } = response
    end

    test "when there are errors, returns an error", %{conn: conn} do
      params = %{
        "age" => 27,
        "address" => "Rua das Bananeiras"
      }

      response =
        conn
        |> post(Routes.users_path(conn, :create, params))
        |> json_response(:bad_request)

      expected_response = %{
        "message" => %{
          "cep" => ["can't be blank"],
          "cpf" => ["can't be blank"],
          "email" => ["can't be blank"],
          "name" => ["can't be blank"],
          "password" => ["can't be blank"]
        }
      }

      assert expected_response == response
    end
  end

  describe "delete/2" do
    test "when there is a user with the given id, deletes the user", %{conn: conn} do
      id = "95d0c007-5cd9-46be-84b6-143a84e5cc2e"
      insert(:user)

      response =
        conn
        |> delete(Routes.users_path(conn, :delete, id))
        |> response(:no_content)

      assert response == ""
    end
  end
end
