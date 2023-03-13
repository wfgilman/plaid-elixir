defmodule Plaid.AssetReport do
  @moduledoc """
  Functions for Plaid `asset report` endpoint.
  """
  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct asset_report_id: nil,
            client_report_id: nil,
            date_generated: nil,
            days_requested: nil,
            items: [],
            user: nil,
            warnings: []

  @type t :: %__MODULE__{
          asset_report_id: String.t(),
          client_report_id: String.t(),
          date_generated: String.t(),
          days_requested: integer(),
          items: [Plaid.AssetReport.Item.t()],
          user: Plaid.AssetReport.User.t(),
          warnings: [Plaid.AssetReport.Warning.t()]
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  defmodule Item do
    @moduledoc """
    Plaid.AssetReport Item data structure.
    """

    @derive Jason.Encoder
    defstruct item_id: nil,
              institution_name: nil,
              institution_id: nil,
              date_last_updated: nil,
              accounts: []

    @type t :: %__MODULE__{
            item_id: String.t(),
            institution_name: String.t(),
            institution_id: String.t(),
            date_last_updated: String.t(),
            accounts: [Plaid.Accounts.Account.t()]
          }
  end

  defmodule User do
    @moduledoc """
    Plaid.AssetReport User data structure.
    """

    @derive Jason.Encoder
    defstruct client_user_id: nil,
              first_name: nil,
              middle_name: nil,
              last_name: nil,
              ssn: nil,
              phone_number: nil,
              email: nil

    @type t :: %__MODULE__{
            client_user_id: String.t(),
            first_name: String.t(),
            middle_name: String.t(),
            last_name: String.t(),
            ssn: String.t(),
            phone_number: String.t(),
            email: String.t()
          }
  end

  defmodule Warning do
    @moduledoc """
    Plaid.AssetReport Warning data structure.
    """
    @derive Jason.Encoder
    defstruct warning_type: nil, warning_code: nil, cause: nil

    @type t :: %__MODULE__{warning_type: String.t(), warning_code: String.t(), cause: Plaid.AssetReport.Warning.Cause.t()}

    defmodule Cause do
      @moduledoc """
      Plaid.AssetReport.Warning Cause data structure.
      """

      @derive Jason.Encoder
      defstruct error_type: nil,
                error_code: nil,
                error_message: nil,
                display_message: nil,
                request_id: nil,
                status: nil,
                documentation_url: nil,
                suggested_action: nil,
                item_id: nil

      @type t :: %__MODULE__{
              error_type: String.t(),
              error_code: String.t(),
              error_message: String.t(),
              display_message: String.t(),
              request_id: String.t(),
              status: integer,
              documentation_url: String.t(),
              suggested_action: String.t(),
              item_id: String.t()
            }
    end
  end

  @doc """
  Creates an asset report.

  Parameters
  ```
  %{
    access_tokens: ["access-env-identifier"],
    days_requested: 356
  }
  ```

  Response
  ```
  {:ok,
    %{asset_report_token: "assets-sandbox-6f12f5bb-22dd-4855-b918-f47ec439198a",
      asset_report_id: "1f414183-220c-44f5-b0c8-bc0e6d4053bb"",
      request_id: "Iam3b"
    }
  }
  ```
  """
  @spec create_asset_report(params, config) :: {:ok, map} | error
  def create_asset_report(params, config \\ %{}) do
    mapper = fn %{"asset_report_token" => t, "asset_report_id" => id, "request_id" => r} ->
      %{asset_report_token: t, asset_report_id: id, request_id: r}
    end

    request_operation("asset_report/create", params, config, mapper)
  end

  defp request_operation(endpoint, params, config, mapper) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(mapper)
  end

  @doc """
  Gets the Asset Report from Plaid.

  Parameters
  ```
  %{
    asset_report_token: "assets-sandbox-6f12f5bb-22dd-4855-b918-f47ec439198a"
  }
  ```
  """
  @spec get(params(), config()) :: {:ok, t()} | error()
  def get(params, config \\ %{}) do
    request_operation("asset_report/get", params, config, &map_asset_report/1)
  end

  defp map_asset_report(%{"report" => report, "warnings" => warnings}) do
    Poison.Decode.transform(Map.put_new(report, "warnings", warnings), %{
      as: %Plaid.AssetReport{
        items: [
          %Plaid.AssetReport.Item{
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
        ],
        user: %Plaid.AssetReport.User{},
        warnings: [
          %Plaid.AssetReport.Warning{
            cause: %Plaid.AssetReport.Warning.Cause{}
          }
        ]
      }
    })
  end
end
