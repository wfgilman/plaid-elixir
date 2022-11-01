defmodule Plaid.Accounts do
  @moduledoc """
  Functions for Plaid `accounts` endpoint.
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

        In the `data` key is a map of relevant address fields. For example:
        ```
        %{
          "city" => "Malakoff",
          "country" => "US",
          "postal_code" => "14236",
          "region": "NY",
          "street": "2992 Cameron Road"
        }
        ```
        """

        @derive Jason.Encoder
        defstruct data: nil,
                  primary: false

        @type t :: %__MODULE__{
                data: map,
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
  @spec get(params, config) :: {:ok, Plaid.Accounts.t()} | error
  def get(params, config \\ %{}) do
    request_operation("accounts/get", params, config)
  end

  defp request_operation(endpoint, params, config) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_accounts(&1))
  end

  defp map_accounts(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Accounts{
          accounts: [
            %Plaid.Accounts.Account{
              balances: %Plaid.Accounts.Account.Balance{},
              owners: [%Plaid.Accounts.Account.Owner{
                  addresses: [%Plaid.Accounts.Account.Owner.Address{}],
                  emails: [%Plaid.Accounts.Account.Owner.Email{}],
                  phone_numbers: [%Plaid.Accounts.Account.Owner.PhoneNumber{}]
              }]
            }
          ],
          item: %Plaid.Item{}
        }
      }
    )
  end

  @doc """
  Gets balance for specified accounts associated with Item.

  Parameters
  ```
  %{access_token: "access-token", options: %{account_ids: ["account-id"]}}
  ```
  """
  @spec get_balance(params, config) :: {:ok, Plaid.Accounts.t()} | error
  def get_balance(params, config \\ %{}) do
    request_operation("accounts/balance/get", params, config)
  end
end
