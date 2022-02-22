defmodule Plaid.Accounts do
  @moduledoc """
  Functions for Plaid `accounts` endpoint.
  """

  import Plaid, only: [validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | [String.t()] | map}
  @type config :: %{required(atom) => String.t()}

  @endpoint :accounts

  defmodule Account do
    @moduledoc """
    Plaid Account data structure.
    """

    @derive Jason.Encoder
    defstruct account_id: nil,
              balances: nil,
              owners: nil,
              name: nil,
              mask: nil,
              official_name: nil,
              type: nil,
              subtype: nil,
              verification_status: nil

    @type t :: %__MODULE__{
            account_id: String.t(),
            balances: Plaid.Accounts.Account.Balance.t(),
            owners: [Plaid.Accounts.Account.Owner.t()],
            name: String.t(),
            mask: String.t(),
            official_name: String.t(),
            type: String.t(),
            subtype: String.t(),
            verification_status: String.t()
          }

    defmodule Balance do
      @moduledoc """
      Plaid Account Balance data structure.
      """

      @derive Jason.Encoder
      defstruct available: nil,
                current: nil,
                limit: nil,
                iso_currency_code: nil,
                unofficial_currency_code: nil

      @type t :: %__MODULE__{
              available: float,
              current: float,
              limit: float,
              iso_currency_code: String.t(),
              unofficial_currency_code: String.t()
            }
    end

    defmodule Owner do
      @moduledoc """
      Plaid Account Owner data structure.
      """

      @derive Jason.Encoder
      defstruct addresses: nil,
                emails: nil,
                names: nil,
                phone_numbers: nil

      @type t :: %__MODULE__{
              addresses: [Plaid.Accounts.Account.Owner.Address.t()],
              emails: [Plaid.Accounts.Account.Owner.Email.t()],
              names: [String.t()],
              phone_numbers: [Plaid.Accounts.Account.Owner.PhoneNumber.t()]
            }

      defmodule Address do
        @moduledoc """
        Plaid Account Owner Address data structure.
        """

        @derive Jason.Encoder
        defstruct data: %{city: nil, region: nil, street: nil, postal_code: nil, country: nil},
                  primary: false

        @type t :: %__MODULE__{
                data: %{
                  city: String.t(),
                  region: String.t(),
                  street: String.t(),
                  postal_code: String.t(),
                  country: String.t()
                },
                primary: boolean()
              }
      end

      defmodule Email do
        @moduledoc """
        Plaid Account Owner Email data structure.
        """

        @derive Jason.Encoder
        defstruct data: nil,
                  primary: false,
                  type: nil

        @type t :: %__MODULE__{
                data: String.t(),
                primary: boolean(),
                type: String.t()
              }
      end

      defmodule PhoneNumber do
        @moduledoc """
        Plaid Account Owner PhoneNumber data structure.
        """

        @derive Jason.Encoder
        defstruct data: nil,
                  primary: false,
                  type: nil

        @type t :: %__MODULE__{
                data: String.t(),
                primary: boolean(),
                type: String.t()
              }
      end
    end
  end

  @doc """
  Gets account data associated with Item.

  Parameters
  ```
  %{access_token: "access-token"}
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Accounts.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    client().make_request_with_cred(:post, endpoint, config, params, %{}, [])
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Gets balance for specified accounts associated with Item.

  Parameters
  ```
  %{access_token: "access-token", options: %{account_ids: ["account-id"]}}
  ```
  """
  @spec get_balance(params, config | nil) :: {:ok, Plaid.Accounts.t()} | {:error, Plaid.Error.t()}
  def get_balance(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/balance/get"

    client().make_request_with_cred(:post, endpoint, config, params, %{}, [])
    |> Utils.handle_resp(@endpoint)
  end

  defp client do
    Application.get_env(:plaid, :client, Plaid)
  end
end
