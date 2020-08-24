defmodule Plaid.Link do
  @moduledoc """
  Functions for Plaid `link` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct link_token: nil,
            expiration: nil,
            request_id: nil

  @type t :: %__MODULE__{
          link_token: String.t(),
          expiration: String.t(),
          request_id: String.t()
        }
  @type params :: %{required(atom) => String.t()}
  @type config :: %{required(atom) => String.t()}

  @endpoint :link

  @doc """
  Creates a Link Token.

  Parameters
  ```
  %{
    client_name: "",
    language: "",
    country_codes: "",
    user: %{client_user_id: ""}
  }
  ```
  """
  @spec create_link_token(params, config | nil) ::
          {:ok, Plaid.Link.t()} | {:error, Plaid.Error.t()}
  def create_link_token(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/token/create"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
