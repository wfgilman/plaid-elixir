defmodule Plaid.Identity do
  @moduledoc """
  Functions for Plaid `identity` endpoint.
  """

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

  @endpoint :identity

  @doc """
  Gets identity data associated with an Item.

  Parameters
  ```
  %{
    access_token: "access-env-identifier"
  }
  ```
  """
  @spec get(params, config) :: {:ok, Plaid.Identity.t()} | error
  def get(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
