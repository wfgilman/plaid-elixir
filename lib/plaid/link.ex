defmodule Plaid.Link do
  @moduledoc """
  Functions for Plaid `link` endpoint.
  """

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
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | Plaid.HTTPClient.Error.t()} | no_return

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
  @spec create_link_token(params, config) :: {:ok, Plaid.Link.t()} | error
  def create_link_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/token/create", params, config)
      |> client.handle_response(@endpoint, config)
    end
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
  @spec get_link_token(params, config) :: {:ok, Plaid.Link.t()} | error
  def get_link_token(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/token/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
