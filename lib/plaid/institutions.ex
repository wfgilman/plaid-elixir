defmodule Plaid.Institutions do
  @moduledoc """
  Functions for working with Plaid Institutions.

  * Return all institutions
  * Fetch an institution by id
  * Return all long-tail institutions
  * Search long-tail institutions

  Plaid API Reference: https://plaid.com/docs/api/#institutions
  """

  alias Plaid.Utilities

  defstruct [:credentials, :has_mfa, :id, :mfa, :name, :product, :type]

  @endpoint "institutions"

  @doc """
  Returns all Plaid Institutions.

  Returns the universe of institutions supported directly by Plaid. This
  endpoint requires no authentication.

  Returns a list of `Plaid.Institutions` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, [%Plaid.Institutions{...}]} = Plaid.Institutions.all()
  {:error, %Plaid.Error{...}} = Plaid.Institutions.all()
  ```
  Plaid API Reference: https://plaid.com/docs/api/#all-institutions
  """
  @spec all() :: {atom, list | map}
  def all() do
    Plaid.make_request(:get, @endpoint)
    |> Utilities.handle_plaid_response(:institutions)
  end

  @doc """
  Fetchs an institution based on the id.

  Returns a specific institution based on the id provided. This endpoint requires
  no authentication.

  Returns a `Plaid.Institutions` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, %Plaid.Institution{...}} = Plaid.Institution.id("55ccd367d32f2fdf19c1c448")
  {:error, %Plaid.Error{...}} = Plaid.Institution.id("55ccd367d32f2fdf19c1c448")
  ```
  Plaid API Reference: https://plaid.com/docs/api/#institutions-by-id
  """
  @spec id(binary) :: {atom, map}
  def id(id) do
    endpoint = @endpoint <> "/" <> id
    Plaid.make_request(:get, endpoint)
    |> Utilities.handle_plaid_response(:institutions)
  end

  @doc """
  Returns long-tail institutions.

  Returns the universe of institutions supported through Plaid's partnerships.
  Results are paginated. This endpoint requires authentication; uses credentials
  supplied in configuration.

  Returns list of `Plaid.LongTailInstitutions` or `Plaid.Error` struct.

  The `%Plaid.LongTailInstitutions{}` struct does not map all the data elements
  returned in the Plaid JSON response. The values ommitted are:
  * video
  * colors
  * logo
  * nameBreak

  ## Example
  ```
  {:ok, [%Plaid.LongTailInstitutions{...}]} = Plaid.Institutions.long_tail(50, 0)
  {:error, %Plaid.Error{...}} = Plaid.Institutions.long_tail(50, 0)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#all-long-tail-institutions
  """
  @spec long_tail(integer, integer) :: {atom, list}
  def long_tail(count, offset) do
    long_tail count, offset, Plaid.config_or_env_cred()
  end

  @doc """
  Returns long-tail institutions with user-supplied credentials.

  ## Example
  ```
  cred = %{client_id: "test_id", secret: "test_secret"}

  {:ok, [%Plaid.LongTailInstitutions{...}]} = Plaid.Institutions.long_tail(50, 0, cred)
  {:error, %Plaid.Error{...}} = Plaid.Institutions.long_tail(50, 0, cred)
  ```
  Plaid API Reference: https://plaid.com/docs/api/#all-long-tail-institutions
  """
  @spec long_tail(integer, integer, map) :: {atom, list}
  def long_tail(count, offset, cred) do
    endpoint = @endpoint <> "/longtail"
    params = %{count: count, offset: offset}
    Plaid.make_request_with_cred(:post, endpoint, cred, params)
    |> Utilities.handle_plaid_response(:long_tail)
  end

  @doc """
  Returns a long-tail institution based on the id.

  Returns the long-tail institution supported through Plaid's partnerships based
  on the id provided. This endpoint requires no authentication.

  The `%Plaid.LongTailInstitutions{}` struct does not map all the data elements
  returned in the Plaid JSON response. The values ommitted are:
  * video
  * colors
  * logo
  * nameBreak

  Returns a `Plaid.LongTailInstitutions` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, %Plaid.LongTailInstitutions{...}} = Plaid.Institutions.long_tail_id("wells")
  {:error, %Plaid.Error{...}} = Plaid.Institutions.long_tail_id("wells")
  ```
  Plaid API Reference: https://plaid.com/docs/api/#institution-search
  """
  @spec long_tail_id(binary) :: {atom, list}
  def long_tail_id(id) do
    params = %{id: id}
    endpoint = @endpoint <> "/search/?" <> Utilities.encode_params(params)
    Plaid.make_request(:get, endpoint)
    |> Utilities.handle_plaid_response(:long_tail)
  end

  @doc """
  Returns long-tail institutions based on query parameters.

  Returns the list of long-tail institutions supported through Plaid's
  partnerships. Long-tail institutions are queried by name using a partial
  match search and product parameter as options. This endpoint does not
  require authentication.

  The `%Plaid.LongTailInstitutions{}` does not map all the data elements returned
  in the Plaid JSON response. The values ommitted are:
  * video
  * colors
  * logo
  * nameBreak

  Returns a list of `Plaid.LongTailInstitutions` or `Plaid.Error` struct.

  ## Example
  ```
  {:ok, [%Plaid.LongTailInstitutions{...}]} = Plaid.Institutions.long_tail_search("wells","auth")
  {:error, %Plaid.Error{...}} = Plaid.Institutions.long_tail_search("wells","auth")
  ```
  Plaid API Reference: https://plaid.com/docs/api/#institution-search
  """
  @spec long_tail_search(binary, binary | nil) :: {atom, map}
  def long_tail_search(query, product \\ nil) do
    params =
      case {query, product} do
        {query, nil} ->
          %{q: query}
        _ ->
          %{q: query, p: product}
      end
    endpoint = @endpoint <> "/search/?" <> Utilities.encode_params(params)
    Plaid.make_request(:get, endpoint)
    |> Utilities.handle_plaid_response(:long_tail)
  end

end

defmodule Plaid.Institutions.Credentials do
  @moduledoc false
  defstruct [:username, :password, :pin]
end
