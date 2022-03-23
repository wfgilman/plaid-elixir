defmodule Plaid.PaymentInitiation.Payments do
  @moduledoc """
  Functions for Plaid `payment_initiation/payment` endpoints.
  """

  @derive Jason.Encoder
  defstruct payments: [],
            next_cursor: nil,
            request_id: nil

  @type t :: %__MODULE__{
          payments: [Plaid.PaymentInitiation.Payments.Payment.t()],
          next_cursor: String.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

  @endpoint :"payment_initiation/payment"

  defmodule Payment do
    @moduledoc """
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

      @derive Jason.Encoder
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

      @derive Jason.Encoder
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
  @spec create(params, config) :: {:ok, Plaid.PaymentInitiation.Payments.Payment.t()} | error
  def create(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec get(params, config) :: {:ok, Plaid.PaymentInitiation.Payments.Payment.t()} | error
  def get(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec list(params, config) :: {:ok, Plaid.PaymentInitiation.Payments.t()} | error
  def list(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/list", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
