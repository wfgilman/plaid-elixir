defmodule Plaid.WebhookVerificationKey do
  @moduledoc """
  Functions for Plaid `webhook_verification_key` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct key: %{},
            request_id: nil

  @type t :: %__MODULE__{
          key: map(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t()}
  @type config :: %{required(atom) => String.t()}

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
  @spec get(params, config | nil) ::
          {:ok, Plaid.Link.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
