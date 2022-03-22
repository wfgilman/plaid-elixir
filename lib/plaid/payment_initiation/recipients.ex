defmodule Plaid.PaymentInitiation.Recipients do
  @moduledoc """
  Functions for Plaid `payment_initiation/recipient` endpoints.
  """

  @derive Jason.Encoder
  defstruct recipients: [], request_id: nil

  @type t :: %__MODULE__{
          recipients: [Plaid.PaymentInitiation.Recipients.Recipient.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

  @endpoint :"payment_initiation/recipient"

  defmodule Recipient do
    @doc """
    Plaid Recipient data structure.
    """

    @derive Jason.Encoder
    defstruct recipient_id: nil,
              name: nil,
              iban: nil,
              address: nil,
              request_id: nil

    @type t :: %__MODULE__{
            recipient_id: String.t(),
            name: String.t(),
            iban: String.t(),
            address: Plaid.PaymentInitiation.Recipients.Recipient.Address.t(),
            request_id: String.t()
          }

    defmodule Address do
      @moduledoc """
      Plaid Recipient Address data structure.
      """

      @derive Jason.Encoder
      defstruct street: nil,
                city: nil,
                postal_code: nil,
                country: nil

      @type t :: %__MODULE__{
              street: [String.t()],
              city: String.t(),
              postal_code: String.t(),
              country: String.t()
            }
    end
  end

  @doc """
  Creates recipient.

  Parameters
  ```
  %{

  }
  ```
  """
  @spec create(params, config) :: {:ok, Plaid.PaymentInitiation.Recipients.Recipient.t()} | error
  def create(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end

  @doc """
  Gets recipient by recipient_id.

  Parameters
  ```
  %{
    recipient_id: ""
  }
  ```
  """
  @spec get(params, config) :: {:ok, Plaid.PaymentInitiation.Recipients.Recipient.t()} | error
  def get(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end

  @doc """
  Lists all recipients.
  """
  @spec list(config) :: {:ok, Plaid.PaymentInitiation.Recipients.t()} | error
  def list(config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/list", %{}, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
