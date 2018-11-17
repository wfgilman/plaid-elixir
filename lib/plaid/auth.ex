defmodule Plaid.Auth do
  @moduledoc """
  Functions for Plaid `auth` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0]

  alias Plaid.Utils

  defstruct accounts: [], item: nil, numbers: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          numbers: [Plaid.Auth.Number.ACH.t()],
          request_id: String.t()
        }
  @type account_ids :: list(Integer.t() | String.t())
  @type cred :: %{required(atom) => String.t()}

  @endpoint "auth"

  defmodule Number do
    @moduledoc """
    Plaid Account Number data structure.

    There are 2 types of numbers that Plaid supports: ACH and EFT, the latter being specific to Canadian banking.
    """

    defmodule ACH do
      @moduledoc """
      Plaid Account Number data structure.
      """

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
    start_date: "2017-01-01",
    end_date: "2017-03-31",
    options: %{
      count: 20,
      offset: 0
    }
  }
  ```
  """
  @spec get(account_ids | [], cred | nil) :: {:ok, Plaid.Auth.t()} | {:error, Plaid.Error.t()}
  def get(account_ids \\ [], cred \\ get_cred()) do
    endpoint = "#{@endpoint}/get"

    :post
    |> make_request_with_cred(endpoint, cred, account_ids)
    |> Utils.handle_resp(:auth)
  end
end
