defmodule Rockelivery.ViaCep.ClientTest do
  use ExUnit.Case

  alias Rockelivery.ViaCep.Client

  describe "get_cep_info/1" do
    setup do
      bypass = Bypass.open()

      {:ok, bypass: bypass}
    end

    test "when there are a valid cep, returns the cep info", %{bypass: bypass} do
      cep = "01001000"

      url = endpoint_url(bypass.port)

      body = ~s({"cep": "01001-000",
        "logradouro": "Praça da Sé",
        "complemento": "lado ímpar",
        "bairro": "Sé",
        "localidade": "São Paulo",
        "uf": "SP",
        "ibge": "3550308",
        "gia": "1004",
        "ddd": "11",
        "siafi": "7107"
      })

      Bypass.expect(bypass, "GET", "#{cep}/json/", fn conn ->
        conn
        |> Plug.Conn.put_resp_header("content-type", "application/json")
        |> Plug.Conn.resp(200, body)
      end)

      response = Client.get_cep_info(url, cep)

      expected_response =
        {:ok, %Rockelivery.ViaCep.ViaCepParams{cep: "01001-000", city: "São Paulo", uf: "SP"}}

      assert expected_response == response
    end

    defp endpoint_url(port), do: "http://localhost:#{port}/"
  end
end
