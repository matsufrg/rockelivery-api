defmodule Rockelivery.ViaCep.ViaCepParams do
  @keys [:cep, :uf, :city]

  @enforce_keys @keys

  defstruct @keys

  def build(cep, uf, city) do
    %__MODULE__{
      cep: cep,
      uf: uf,
      city: city
    }
  end
end
