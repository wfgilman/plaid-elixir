defmodule Plaid.Institutions do
  @moduledoc """
  Functions for Plaid `institutions` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0, get_key: 0]

  alias Plaid.Utils

  @derive Jason.Encoder
  defstruct institutions: [], request_id: nil, total: nil

  @type t :: %__MODULE__{
          institutions: [Plaid.Institutions.Institution.t()],
          request_id: String.t(),
          total: integer
        }
  @type params :: %{required(atom) => integer | String.t() | list}
  @type config :: %{required(atom) => String.t()}

  @endpoint :institutions

  defmodule Institution do
    @moduledoc """
    Plaid Institution data structure.
    """

    @derive Jason.Encoder
    defstruct brand_name: nil,
              brand_subheading: nil,
              colors: nil,
              credentials: [],
              has_mfa: nil,
              health_status: nil,
              institution_id: nil,
              legacy_institution_code: nil,
              legacy_institution_type: nil,
              link_health_status: nil,
              logo: nil,
              mfa: [],
              mfa_code_type: nil,
              name: nil,
              name_break: nil,
              portal: nil,
              products: [],
              request_id: nil,
              url: nil,
              url_account_locked: nil,
              url_account_setup: nil,
              url_forgotten_password: nil

    @type t :: %__MODULE__{
            brand_name: String.t(),
            brand_subheading: String.t(),
            colors: Plaid.Institutions.Institution.Colors.t(),
            credentials: [Plaid.Institutions.Institution.Credentials.t()],
            has_mfa: false | true,
            health_status: String.t(),
            institution_id: String.t(),
            legacy_institution_code: String.t(),
            legacy_institution_type: String.t(),
            link_health_status: String.t(),
            logo: String.t(),
            mfa: [String.t()],
            mfa_code_type: String.t(),
            name: String.t(),
            name_break: String.t(),
            portal: String.t(),
            products: [String.t()],
            request_id: String.t(),
            url: String.t(),
            url_account_locked: String.t(),
            url_account_setup: String.t(),
            url_forgotten_password: String.t()
          }

    defmodule Colors do
      @moduledoc """
      Plaid Institution Colors data structure.
      """

      @derive Jason.Encoder
      defstruct dark: nil, darker: nil, light: nil, primary: nil

      @type t :: %__MODULE__{
              dark: String.t(),
              darker: String.t(),
              light: String.t(),
              primary: String.t()
            }
    end

    defmodule Credentials do
      @moduledoc """
      Plaid Institution Credentials data structure.
      """

      @derive Jason.Encoder
      defstruct label: nil, name: nil, type: nil
      @type t :: %__MODULE__{label: String.t(), name: String.t(), type: String.t()}
    end
  end

  @doc """
  Gets all institutions. Results paginated.

  Parameters
  ```
  %{count: 50, offset: 0}
  ```
  """
  @spec get(params, config | nil) :: {:ok, Plaid.Institutions.t()} | {:error, Plaid.Error.t()}
  def get(params, config \\ %{}) do
    config = get_cred() |> Map.merge(config) |> Map.drop([:public_key])
    endpoint = "#{@endpoint}/get"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end

  @doc """
  Gets an institution by id.
  """
  @spec get_by_id(String.t(), config | nil) ::
          {:ok, Plaid.Institutions.Institution.t()} | {:error, Plaid.Error.t()}
  def get_by_id(id, config \\ %{}) do
    config = get_key() |> Map.merge(config) |> Map.drop([:client_id, :secret])
    params = %{institution_id: id}
    endpoint = "#{@endpoint}/get_by_id"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(:institution)
  end

  @doc """
  Searches institutions by name and product.

  Parameters
  ```
  %{query: "Wells", products: ["transactions"], options: %{limit: 40, include_display_data: true}}
  ```
  """
  @spec search(params, config | nil) :: {:ok, Plaid.Institutions.t()} | {:error, Plaid.Error.t()}
  def search(params, config \\ %{}) do
    config = get_key() |> Map.merge(config) |> Map.drop([:client_id, :secret])
    endpoint = "#{@endpoint}/search"

    make_request_with_cred(:post, endpoint, config, params)
    |> Utils.handle_resp(@endpoint)
  end
end
