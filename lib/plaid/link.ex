defmodule Plaid.Link do
  @moduledoc """
  Functions for Plaid `link` endpoint.
  """

  alias Plaid.Client.Request
  alias Plaid.Client

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
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

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
    request_operation("link/token/create", params, config)
  end

  defp request_operation(endpoint, params, config) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: endpoint, body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_link(&1))
  end

  defp map_link(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.Link{metadata: %Plaid.Link.Metadata{}}
      }
    )
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
    request_operation("link/token/get", params, config)
  end
end
