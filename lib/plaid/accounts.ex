defmodule Plaid.Accounts do
  @moduledoc """
  Functions for Plaid `accounts` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | map}
  @type cred :: %{required(atom) => String.t()}

  @endpoint :accounts

  defmodule Account do
    @moduledoc """
    Plaid Account data structure.
    """

    @derive Jason.Encoder
    defstruct account_id: nil,
              balances: nil,
              name: nil,
              mask: nil,
              official_name: nil,
              type: nil,
              subtype: nil

    @type t :: %__MODULE__{
            account_id: String.t(),
            balances: Plaid.Accounts.Account.Balance.t(),
            name: String.t(),
            mask: String.t(),
            official_name: String.t(),
            type: String.t(),
            subtype: String.t()
          }

    defmodule Balance do
      @moduledoc """
      Plaid Account Balance data structure.
      """

      @derive Jason.Encoder
      defstruct available: nil, current: nil, limit: nil
      @type t :: %__MODULE__{available: float, current: float, limit: float}
    end
  end

  @doc """
  Gets account data associated with Item.

  Parameters
  ```
  %{access_token: "access-token"}
  ```
  """
  @spec get(params, cred | nil) :: {:ok, Plaid.Accounts.t()} | {:error, Plaid.Error.t()}
  def get(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Gets balance for specifed accounts associated with Item.

  Parameters
  ```
  %{access_token: "access-token", options: %{account_ids: ["account-id"]}}
  ```
  """
  @spec get_balance(params, cred | nil) :: {:ok, Plaid.Accounts.t()} | {:error, Plaid.Error.t()}
  def get_balance(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/balance/get"

    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(@endpoint)
  end
end
