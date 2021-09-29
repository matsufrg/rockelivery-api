defmodule Rockelivery.Users.Create do
  alias Rockelivery.{Error, Repo, User}
  alias Rockelivery.ViaCep.{Client, ViaCepParams}

  def call(%{"cep" => cep} = params) do
    changeset = User.changeset(params)

    with {:ok, %User{}} <- User.build(changeset),
         {:ok, %ViaCepParams{} = cep_info} <- Client.get_cep_info(cep),
         {:ok, %User{}} = user <- create_user(params, cep_info) do
      user
    else
      {:error, %Error{}} = error -> error
      {:error, result} -> {:error, Error.build(:bad_request, result)}
    end
  end

  def create_user(params, cep_info) do
    params
    |> merge_params(cep_info)
    |> User.changeset()
    |> Repo.insert()
  end

  def merge_params(params, %ViaCepParams{uf: uf, city: city}) do
    Map.merge(%{"city" => city, "UF" => uf}, params)
  end
end
