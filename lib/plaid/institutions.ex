defmodule Plaid.Institutions do
  @moduledoc """
  Functions for Plaid `institutions` endpoint.
  """

  import Plaid, only: [make_request_with_cred: 4, get_cred: 0, get_key: 0]

  alias Plaid.Utils

  defstruct institutions: [], request_id: nil, total: nil

  @type t :: %__MODULE__{institutions: [Plaid.Institutions.Institution.t],
                         request_id: String.t,
                         total: integer}
  @type params :: %{required(atom) => integer | String.t | list}
  @type cred :: %{required(atom) => String.t}
  @type key :: %{public_key: String.t}

  @endpoint "institutions"

  defmodule Institution do
    @moduledoc """
    Plaid Institution data structure.
    """

    defstruct credentials: [], has_mfa: nil, institution_id: nil, mfa: [],
              name: nil, products: [], request_id: nil
    @type t :: %__MODULE__{credentials: [Plaid.Institutions.Institution.Credentials.t],
                           has_mfa: false | true,
                           institution_id: String.t,
                           mfa: [String.t],
                           name: String.t,
                           products: [String.t],
                           request_id: String.t}

    defmodule Credentials do
      @moduledoc """
      Plaid Institution Credentials data structure.
      """

      defstruct label: nil, name: nil, type: nil
      @type t :: %__MODULE__{label: String.t, name: String.t, type: String.t}
    end

  end

  @doc """
  Gets all institutions. Results paginated.

  Parameters
  ```
  %{count: 50, offset: 0}
  ```
  """
  @spec get(params, cred | nil) :: {:ok, Plaid.Institutions.t} | {:error, Plaid.Error.t}
  def get(params, cred \\ get_cred()) do
    endpoint = "#{@endpoint}/get"
    make_request_with_cred(:post, endpoint, cred, params)
    |> Utils.handle_resp(:institutions)
  end

  @doc """
  Gets an institution by id.
  """
  @spec get_by_id(String.t, key | nil) :: {:ok, Plaid.Institutions.Institution.t} | {:error, Plaid.Error.t}
  def get_by_id(id, key \\ get_key()) do
    params = %{institution_id: id}
    endpoint = "#{@endpoint}/get_by_id"
    make_request_with_cred(:post, endpoint, key, params)
    |> Utils.handle_resp(:institution)
  end

  @doc """
  Searches institutions by name and product.

  Parameters
  ```
  %{query: "Wells", products: ["transactions"]}
  ```
  """
  @spec search(params, key | nil) :: {:ok, Plaid.Institutions.t} | {:error, Plaid.Error.t}
  def search(params, key \\ get_key()) do
    endpoint = "#{@endpoint}/search"
    make_request_with_cred(:post, endpoint, key, params)
    |> Utils.handle_resp(:institutions)
  end

end
