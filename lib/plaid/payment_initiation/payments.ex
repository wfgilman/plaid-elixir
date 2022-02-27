defmodule Plaid.PaymentInitiation.Payments do
  @moduledoc """
  Functions for Plaid `payment_initiation/payment` endpoints.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct payments: [],
            next_cursor: nil,
            request_id: nil

  @type t :: %__MODULE__{
          payments: [Plaid.PaymentInitiation.Payments.Payment.t()],
          next_cursor: String.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | map}
  @type config :: %{required(atom) => String.t()}

  @endpoint :"payment_initiation/payment"

  defmodule Payment do
    @doc """
    Plaid Payment data structure.
    """

    @derive Jason.Encoder
    defstruct payment_id: nil,
              payment_token: nil,
              payment_token_expiration_time: nil,
              reference: nil,
              amount: nil,
              status: nil,
              last_status_update: nil,
              recipient_id: nil,
              schedule: nil,
              request_id: nil

    @type t :: %__MODULE__{
            payment_id: String.t(),
            payment_token: String.t(),
            payment_token_expiration_time: String.t(),
            reference: String.t(),
            amount: Plaid.PaymentInitiation.Payments.Payment.Amount.t(),
            status: String.t(),
            last_status_update: String.t(),
            recipient_id: String.t(),
            schedule: Plaid.PaymentInitiation.Payments.Payment.Schedule.t(),
            request_id: String.t()
          }

    defmodule Amount do
      @moduledoc """
      Plaid Payment Amount data structure.
      """

      defstruct currency: nil,
                amount: 0

      @type t :: %__MODULE__{
              currency: String.t(),
              amount: float
            }
    end

    defmodule Schedule do
      @moduledoc """
      Plaid Payment Schedule data structure.
      """

      defstruct interval: nil,
                interval_execution_day: nil,
                start_date: nil

      @type t :: %__MODULE__{
              interval: String.t(),
              interval_execution_day: integer(),
              start_date: String.t()
            }
    end
  end

  @doc """
  Creates payment.

  Parameters
  ```
  %{
    recipient_id: "",
    reference: "",
    amount: %{
      currency: "",
      value: 0.00
    },
    schedule: %{
      interval: "",
      interval_execution_day: 1,
      start_date: ""
    },
  }
  ```
  """
  @spec create(params, config | nil) ::
          {:ok, Plaid.PaymentInitiation.Payments.t()} | {:error, Plaid.Error.t()}
  def create(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Gets payment by payment_id.

  Parameters
  ```
  %{
    payment_id: ""
  }
  ```
  """
  @spec get(params, config | nil) ::
          {:ok, Plaid.PaymentInitiation.Payments.Payment.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Lists all payments.

  Parameters
  ```
  %{
    options: %{
      count: 1,
      cursor: ""
    }
  }
  ```
  """
  @spec list(params, config | nil) ::
          {:ok, [Plaid.PaymentInitiation.Payments.Payment.t()]} | {:error, Plaid.Error.t()}
  def list(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/list"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
