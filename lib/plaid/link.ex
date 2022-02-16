defmodule Plaid.Link do
  @moduledoc """
  Functions for Plaid `link` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, validate_cred: 1]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct link_token: nil,
            expiration: nil,
            # Deprecated, not returned by Plaid.
            request_id: nil,
            created_at: nil,
            metadata: nil

  @type t :: %__MODULE__{
          link_token: String.t(),
          expiration: String.t(),
          request_id: String.t(),
          created_at: String.t(),
          metadata: Plaid.Link.Metadata.t()
        }
  @type params :: %{required(atom) => String.t() | [String.t()] | map}
  @type config :: %{required(atom) => String.t()}

  @endpoint :link

  defmodule Metadata do
    @moduledoc """
    Plaid Link Metadata data structure.
    """

    @derive Jason.Encoder
    defstruct initial_products: nil,
              webhook: nil,
              country_codes: nil,
              language: nil,
              account_filters: nil,
              redirect_uri: nil,
              products: nil,
              client_name: nil,
              user: nil,
              access_token: nil

    @type t :: %__MODULE__{
            initial_products: [String.t()],
            products: [String.t()],
            webhook: String.t(),
            country_codes: [String.t()],
            language: String.t(),
            account_filters: map(),
            redirect_uri: String.t(),
            client_name: String.t(),
            user: map(),
            access_token: String.t()
          }
  end

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

  @doc """
  Gets a Link Token's information.

  Parameters
  ```
  %{
    link_token: ""
  }
  ```
  """
  @spec get_link_token(params, config | nil) ::
          {:ok, Plaid.Link.t()} | {:error, Plaid.Error.t()}
  def get_link_token(params, config \\ %{}) do
    config = validate_cred(config)
    endpoint = "#{@endpoint}/token/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
