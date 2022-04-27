defmodule Plaid.AssetReport do
  @moduledoc """
  Functions for Plaid `asset report` endpoint.
  """
  alias Plaid.Client.Request, as: ClientRequest
  alias Plaid.Client

  defmodule Request do
    @derive Jason.Encoder
    defstruct asset_report_token: nil, asset_report_id: nil, request_id: nil

    @type t :: %__MODULE__{
            asset_report_token: String.t(),
            asset_report_id: String.t(),
            request_id: String.t()
          }
  end

  defmodule Report do
    @moduledoc """
    Main data of an asset report.
    """

    defmodule User do
      @moduledoc """
      Additional information of the user for the asset report.
      """

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

    defstruct asset_report_id: nil,
              client_report_id: nil,
              date_generated: nil,
              days_requested: nil

    @type t :: %__MODULE__{
            asset_report_id: String.t(),
            client_report_id: String.t(),
            date_generated: String.t(),
            days_requested: integer()
          }
  end

  defmodule Item do
    @moduledoc """
    Data about each of the items in the asset report.
    """

    defstruct item_id: nil,
              institution_name: nil,
              institution_id: nil,
              date_last_updated: nil,
              accounts: nil

    @type t :: %__MODULE__{
            item_id: String.t(),
            institution_name: String.t(),
            institution_id: String.t(),
            date_last_updated: String.t(),
            accounts: [Plaid.Accounts.Account.t()]
          }
  end

  defmodule Warning do
    @moduledoc """
    Detailed warnings for an asset report.
    """

    defmodule Cause do
      @moduledoc """
      Detailed cause of warning for an asset report.
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
              status: number(),
              documentation_url: String.t(),
              suggested_action: String.t(),
              item_id: String.t()
            }
    end

    @derive Jason.Encoder
    defstruct warning_type: "ASSET_REPORT_WARNING", warning_code: "OWNERS_UNAVAILABLE", cause: nil

    @type t :: %__MODULE__{warning_type: String.t(), warning_code: String.t(), cause: Cause.t()}
  end

  defstruct report: nil, request_id: nil, warnings: nil

  @type t :: %__MODULE__{report: Report.t(), request_id: String.t(), warnings: [Warning.t()]}

  @type options :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  @doc """
  Creates an asset report.

  Parameters
  ```
  ["access-env-identifier"], 356, %{}
  ```
  """
  @spec create_asset_report([String.t()], integer(), options(), config()) ::
          {:ok, Request.t()} | error()
  def create_asset_report(access_tokens, days_requested, options \\ %{}, config \\ %{}) do
    request_operation(
      "asset_report/create",
      %{access_tokens: access_tokens, days_requested: days_requested, options: options},
      config, &map_asset_report_request/1
    )
  end

  @doc """
  """
  @spec get(String.t(), boolean(), config()) :: {:ok, t()} | error()
  def get(asset_report_token, include_insights \\ false, config \\ %{}) do
    request_operation(
      "asset_report/get",
      %{asset_report_token: asset_report_token, include_insights: include_insights},
      config, &map_asset_report/1
    )
  end

  defp request_operation(endpoint, params, config, mapper) do
    c = config[:client] || Plaid

    ClientRequest
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> ClientRequest.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&mapper.(&1))
  end

  defp map_asset_report_request(body), do: Poison.Decode.transform(body, %{as: %Request{}})

  defp map_asset_report(body), do: Poison.Decode.transform(body, %{as: %__MODULE__{}})
end
