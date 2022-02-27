defmodule Plaid.PaymentInitiation.Recipients do
  @moduledoc """
  Functions for Plaid `payment_initiation/recipient` endpoints.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct recipients: [], request_id: nil

  @type t :: %__MODULE__{
          recipients: [Plaid.PaymentInitiation.Recipients.Recipient.t()],
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t() | map}
  @type config :: %{required(atom) => String.t()}

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
  @spec create(params, config | nil) ::
          {:ok, Plaid.PaymentInitiation.Recipients.t()} | {:error, Plaid.Error.t()}
  def create(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
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
  @spec get(params, config | nil) ::
          {:ok, Plaid.PaymentInitiation.Recipients.Recipient.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Lists all recipients.
  """
  @spec list(config | nil) ::
          {:ok, [Plaid.PaymentInitiation.Recipients.Recipient.t()]} | {:error, Plaid.Error.t()}
  def list(config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/list"

    make_request_with_cred(:post, endpoint, config, %{})
    |> Utils.handle_resp(@endpoint)
  end
end
