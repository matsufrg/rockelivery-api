defmodule Rockelivery.Factory do
  use ExMachina.Ecto, repo: Rockelivery.Repo

  alias Rockelivery.User

  def user_params_factory do
    %{
      age: 27,
      address: "Rua das Bananeiras",
      cep: "12345678",
      cpf: "12345678900",
      email: "roberto.marques@impar.com.br",
      password: "123456",
      name: "Roberto"
    }
  end

  def user_factory do
    %User{
      age: 27,
      address: "Rua das Bananeiras",
      cep: "12345678",
      cpf: "12345678900",
      email: "roberto.marques@impar.com.br",
      password: "123456",
      name: "Roberto",
      id: "95d0c007-5cd9-46be-84b6-143a84e5cc2e"
    }
  end
end
