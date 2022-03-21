defmodule Plaid.WebhookVerificationKey do
  @moduledoc """
  Functions for Plaid `webhook_verification_key` endpoint.
  """

  @derive Jason.Encoder
  defstruct key: %{},
            request_id: nil

  @type t :: %__MODULE__{
          key: map(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | PlaidHTTP.Error.t()} | no_return

  @endpoint :webhook_verification_key

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
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, params)
    end
  end
end
