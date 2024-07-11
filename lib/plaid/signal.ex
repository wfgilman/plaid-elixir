defmodule Plaid.Signal do
  @moduledoc """
  Functions for Plaid `signal` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct scores: nil,
            core_attributes: nil,
            ruleset: nil,
            warnings: [],
            request_id: nil

  @type t :: %__MODULE__{
          scores: Plaid.Signal.Scores.t(),
          core_attributes: map(),
          ruleset: Plaid.Signal.Ruleset.t(),
          warnings: [Plaid.Signal.Warning.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  defmodule Scores do
    @moduledoc """
    Plaid Signal Scores data structure
    """

    @derive Jason.Encoder
    defstruct customer_initiated_return_risk: nil,
              bank_initiated_return_risk: nil

    @type t :: %__MODULE__{
            customer_initiated_return_risk: Plaid.Signal.Scores.Risk.t(),
            bank_initiated_return_risk: Plaid.Signal.Scores.Risk.t()
          }

    defmodule Risk do
      @moduledoc """
      Plaid Signal Scores Risk data structure.
      """

      @derive Jason.Encoder
      defstruct score: nil, risk_tier: nil
      @type t :: %__MODULE__{score: integer(), risk_tier: integer()}
    end
  end

  defmodule Ruleset do
    @moduledoc """
    Plaid Signal Ruleset data structure
    """

    @derive Jason.Encoder
    defstruct ruleset_key: nil,
              outcome: nil

    @type t :: %__MODULE__{
            ruleset_key: String.t(),
            outcome: String.t()
          }
  end

  defmodule Warning do
    @moduledoc """
    Plaid Signal Warning data structure
    """

    @derive Jason.Encoder
    defstruct warning_type: nil,
              warning_code: nil,
              warning_message: nil

    @type t :: %__MODULE__{
            warning_type: String.t(),
            warning_code: String.t(),
            warning_message: String.t()
          }
  end

  @doc """
  Evaluate a planned ACH transaction.

  Parameters
  ```
  %{
    access_token: "access-sandbox-71e02f71-0960-4a27-abd2-5631e04f2175",
    account_id: "3gE5gnRzNyfXpBK5wEEKcymJ5albGVUqg77gr",
    client_transaction_id: "txn12345",
    amount: 123.45,
    client_user_id: "user1234",
    user: %{
      name: %{
        prefix: "Ms.",
        given_name: "Jane",
        middle_name: "Leah",
        family_name: "Doe",
        suffix: "Jr.",
      },
      phone_number: "+14152223333",
      email_address: "jane.doe@example.com",
      address: %{
        street: "2493 Leisure Lane",
        city: "San Matias",
        region: "CA",
        postal_code: "93405-2255",
        country: "US",
      },
    },
    device: %{
      ip_address: "198.30.2.2",
      user_agent: "Mozilla/5.0 (iPhone; CPU iPhone OS 13_5_1 like Mac OS X)",
    },
    user_present: true,
    is_recurring: false
  }
  ```
  """
  @spec evaluate(params, config) :: {:ok, Plaid.Signal.t()} | error
  def evaluate(params, config \\ %{}) do
    request_operation("signal/evaluate", params, config, &map_signal/1)
  end

  @doc """
  Report whether the ACH transaction was initiated

  Parameters
  ```
  %{
    client_transaction_id: "txn12345",
    initiated: true,
    days_funds_on_hold: 3,
    decision_outcome: "APPROVE",
    payment_method: "NEXT_DAY_ACH",
    amount_instantly_available: 102.25
  }
  ```

  Response
  ```
  {:ok, %{request_id: "a325fa"}}
  ```
  """
  @spec report_decision(params, config) :: {:ok, map} | error
  def report_decision(params, config \\ %{}) do
    request_operation("signal/decision/report", params, config, &map_request_id/1)
  end

  @doc """
  Report whether the ACH transaction was returned

  Parameters
  ```
  %{
    client_transaction_id: "txn12345",
    return_code: "R01",
    returned_at: "2024-07-11T10:16:24Z"
  }
  ```

  Response
  ```
  {:ok, %{request_id: "a325fa"}}
  ```
  """
  @spec report_return(params, config) :: {:ok, map} | error
  def report_return(params, config \\ %{}) do
    request_operation("signal/return/report", params, config, &map_request_id/1)
  end

  @doc """
  When Link is not initialized with Signal, call /signal/prepare to opt-in that
  Item to the Signal data collection process, developing a Signal score.
  If run on an Item that is already initialized with Signal,
  this endpoint will return a 200 response and will not modify the Item.

  Parameters
  ```
  %{
    access_token: 'access-sandbox-71e02f71-0960-4a27-abd2-5631e04f2175'
  }
  ```

  Response
  ```
  {:ok, %{request_id: "a325fa"}}
  ```
  """
  @spec prepare(params, config) :: {:ok, map} | error
  def prepare(params, config \\ %{}) do
    request_operation("signal/prepare", params, config, &map_request_id/1)
  end

  defp map_signal(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Signal{
          scores: %Plaid.Signal.Scores{
            customer_initiated_return_risk: %Plaid.Signal.Scores.Risk{},
            bank_initiated_return_risk: %Plaid.Signal.Scores.Risk{},
          },
          warnings: [%Plaid.Signal.Warning{}],
          ruleset: %Plaid.Signal.Ruleset{}
        }
      }
    )
  end

  defp map_request_id(%{"request_id" => r}) do
    %{request_id: r}
  end

  defp request_operation(endpoint, params, config, mapper) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(mapper)
  end
end
