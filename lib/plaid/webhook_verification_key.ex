defmodule Plaid.WebhookVerificationKey do
  @moduledoc """
  Functions for Plaid `webhook_verification_key` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct key: %{},
            request_id: nil

  @type t :: %__MODULE__{
          key: map(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  @doc """
  Gets a webhook verification key (JWK).

  Parameters
  ```
  %{
    key_id: "The key ID (kid) from the webhook's JWT header."
  }
  ```
  """
  @spec get(params, config) :: {:ok, Plaid.WebhookVerificationKey.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "webhook_verification_key/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&Poison.Decode.transform(&1, %{as: %Plaid.WebhookVerificationKey{}}))
  end
end
