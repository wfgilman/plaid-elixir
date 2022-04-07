defmodule Plaid.Identity do
  @moduledoc """
  Functions for Plaid `identity` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "identity/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_identity(&1))
  end

  defp map_identity(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Identity{
          item: %Plaid.Item{},
          accounts: [
            %Plaid.Accounts.Account{
              balances: %Plaid.Accounts.Account.Balance{},
              owners: [
                %Plaid.Accounts.Account.Owner{
                  addresses: [%Plaid.Accounts.Account.Owner.Address{}],
                  emails: [%Plaid.Accounts.Account.Owner.Email{}],
                  phone_numbers: [%Plaid.Accounts.Account.Owner.PhoneNumber{}]
                }
              ]
            }
          ]
        }
      }
    )
  end
end
