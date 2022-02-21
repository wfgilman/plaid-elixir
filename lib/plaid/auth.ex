defmodule Plaid.Auth do
  @moduledoc """
  Functions for Plaid `auth` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct accounts: [], item: nil, numbers: [], request_id: nil

  @type t :: %__MODULE__{
          accounts: [Plaid.Accounts.Account.t()],
          item: Plaid.Item.t(),
          numbers: %{
            ach: [Plaid.Auth.Numbers.ACH.t()],
            eft: [Plaid.Auth.Numbers.EFT.t()],
            international: [Plaid.Auth.Numbers.International.t()],
            bacs: [Plaid.Auth.Numbers.BACS.t()]
          },
          request_id: String.t()
        }
  @type params :: %{
          required(:access_token) => String.t(),
          optional(:options) => %{
            optional(:account_ids) => [String.t()]
          }
        }
  @type config :: %{
          required(atom) => String.t(),
          optional(:httpoison_options) => [map()]
        }

  @endpoint :auth

  defmodule Numbers do
    @moduledoc """
    Plaid Account Number data structure.

    There are 2 types of numbers that Plaid supports: ACH and EFT, the latter being specific to Canadian banking.
    """

    @derive Jason.Encoder
    defstruct ach: [], eft: [], international: [], bacs: []

    @type t :: %__MODULE__{
            ach: [Plaid.Auth.Numbers.ACH.t()],
            eft: [Plaid.Auth.Numbers.EFT.t()],
            international: [Plaid.Auth.Numbers.International.t()],
            bacs: [Plaid.Auth.Numbers.BACS.t()]
          }

    defmodule ACH do
      @moduledoc """
      Plaid Account Number ACH data structure.
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

    defmodule EFT do
      @moduledoc """
      Plaid Account Number EFT data structure
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, institution: nil, branch: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              institution: String.t(),
              branch: String.t()
            }
    end

    defmodule International do
      @moduledoc """
      Plaid Account Number Institution data structure.
      """

      @derive Jason.Encoder
      defstruct account_id: nil, bic: nil, iban: nil

      @type t :: %__MODULE__{
              account_id: String.t(),
              bic: String.t(),
              iban: String.t()
            }
    end

    defmodule BACS do
      @moduledoc """
      Plaid Account Number BACS data structure.
      """

      @derive Jason.Encoder
      defstruct account: nil, account_id: nil, sort_code: nil

      @type t :: %__MODULE__{
              account: String.t(),
              account_id: String.t(),
              sort_code: String.t()
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
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    :post
    |> make_request_with_cred(endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
