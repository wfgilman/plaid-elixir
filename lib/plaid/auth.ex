defmodule Plaid.Auth do
  @moduledoc """
  Functions for Plaid `auth` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, numbers: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          numbers: [Plaid.Auth.Number.ACH.t()],
          request_id: String.t()
        }
  @type params :: %{
          required(:access_token) => String.t(),
          optional(:options) => %{
            optional(:account_ids) => [String.t()]
          }
        }
  @type config :: %{required(atom) => String.t()}

  @endpoint :auth

  defmodule Numbers do
    @moduledoc """
    Plaid Account Number data structure.

    There are 2 types of numbers that Plaid supports: ACH and EFT, the latter being specific to Canadian banking.
    """

    @derive Jason.Encoder
    defstruct ach: [], eft: []

    @type t :: %__MODULE__{
            ach: [Plaid.Auth.Numbers.ACH.t()]
          }

    defmodule ACH do
      @moduledoc """
      Plaid Account Number data structure.
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, routing: nil, wire_routing: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              routing: String.t(),
              wire_routing: String.t()
            }
    end
  end

  @doc """
  Gets auth data associated with an Item.

  Parameters
  ```
  %{
    access_token: "access-env-identifier",
    options: %{
      account_ids: [
      ]
    }
  }
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Auth.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = Map.merge(get_cred(), config)
    endpoint = "#{@endpoint}/get"

    :post
    |> make_request_with_cred(endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
