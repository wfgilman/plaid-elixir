defmodule Plaid.PaymentInitiation.Payments do
  @moduledoc """
  Functions for Plaid `payment_initiation/payment` endpoints.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

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
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
    request_operation("payment_initiation/payment/create", params, config, &map_payment(&1))
  end

  defp request_operation(endpoint, params, config, mapper) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(mapper)
  end

  defp map_payments(body) do
    Poison.Decode.transform(body, %{
      as: %Plaid.PaymentInitiation.Payments{payments: [full_struct()]}
    })
  end

  defp map_payment(body) do
    Poison.Decode.transform(body, %{as: full_struct()})
  end

  defp full_struct do
    %Plaid.PaymentInitiation.Payments.Payment{
      amount: %Plaid.PaymentInitiation.Payments.Payment.Amount{},
      schedule: %Plaid.PaymentInitiation.Payments.Payment.Schedule{}
    }
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
    request_operation("payment_initiation/payment/get", params, config, &map_payment(&1))
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
    request_operation("payment_initiation/payment/list", params, config, &map_payments(&1))
  end
end
