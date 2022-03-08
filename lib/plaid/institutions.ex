defmodule Plaid.Institutions do
  @moduledoc """
  Functions for Plaid `institutions` endpoint.
  """

  @derive Jason.Encoder
  defstruct institutions: [], request_id: nil, total: nil

  @type t :: %__MODULE__{
          institutions: [Plaid.Institutions.Institution.t()],
          request_id: String.t(),
          total: integer
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | HTTPoison.Error.t()} | no_return

  @endpoint :institutions

  defmodule Institution do
    @moduledoc """
    Plaid Institution data structure.
    """

    @derive Jason.Encoder
    defstruct country_codes: [],
              credentials: [],
              has_mfa: nil,
              input_spec: nil,
              institution_id: nil,
              logo: nil,
              mfa: [],
              mfa_code_type: nil,
              name: nil,
              oauth: nil,
              primary_color: nil,
              products: [],
              request_id: nil,
              routing_numbers: [],
              status: nil,
              url: nil

    @type t :: %__MODULE__{
            country_codes: [String.t()],
            credentials: [Plaid.Institutions.Institution.Credentials.t()],
            has_mfa: false | true,
            input_spec: String.t(),
            institution_id: String.t(),
            logo: String.t(),
            mfa: [String.t()],
            mfa_code_type: String.t(),
            name: String.t(),
            oauth: boolean(),
            primary_color: String.t(),
            products: [String.t()],
            request_id: String.t(),
            routing_numbers: [String.t()],
            status: Plaid.Institutions.Institution.Status.t(),
            url: String.t()
          }

    defmodule Credentials do
      @moduledoc """
      Plaid Institution Credentials data structure.
      """

      @derive Jason.Encoder
      defstruct label: nil, name: nil, type: nil
      @type t :: %__MODULE__{label: String.t(), name: String.t(), type: String.t()}
    end

    defmodule Status do
      @moduledoc """
      Plaid Institution Status data structure.
      """

      @derive Jason.Encoder
      defstruct item_logins: nil,
                transactions_updates: nil,
                auth: nil,
                balance: nil,
                identity: nil

      @type t :: %__MODULE__{
              item_logins: Plaid.Institutions.Institution.Status.ItemLogins.t(),
              transactions_updates: Plaid.Institutions.Institution.Status.TransactionsUpdates.t(),
              auth: Plaid.Institutions.Institution.Status.Auth.t(),
              balance: Plaid.Institutions.Institution.Status.Balance.t(),
              identity: Plaid.Institutions.Institution.Status.Identity.t()
            }

      defmodule ItemLogins do
        @moduledoc """
        Plaid Institution Item Logins Status data structure.
        """

        @derive Jason.Encoder
        defstruct status: nil, last_status_change: nil, breakdown: nil

        @type t :: %__MODULE__{
                status: String.t(),
                last_status_change: String.t(),
                breakdown: Plaid.Institutions.Institution.Status.ItemLogins.Breakdown.t()
              }

        defmodule Breakdown do
          @moduledoc """
          Plaid Institution Item Logins Breakdown Status data structure.
          """

          @derive Jason.Encoder
          defstruct success: nil, error_plaid: nil, error_institution: nil

          @type t :: %__MODULE__{
                  success: number(),
                  error_plaid: number(),
                  error_institution: number()
                }
        end
      end

      defmodule TransactionsUpdates do
        @moduledoc """
        Plaid Institution Transactions Updates Status data structure.
        """

        @derive Jason.Encoder
        defstruct status: nil, last_status_change: nil, breakdown: nil

        @type t :: %__MODULE__{
                status: String.t(),
                last_status_change: String.t(),
                breakdown: Plaid.Institutions.Institution.Status.TransactionsUpdates.Breakdown.t()
              }

        defmodule Breakdown do
          @moduledoc """
          Plaid Institution Transaction Updates Breakdown Status data structure.
          """

          @derive Jason.Encoder
          defstruct refresh_interval: nil,
                    success: nil,
                    error_plaid: nil,
                    error_institution: nil

          @type t :: %__MODULE__{
                  refresh_interval: String.t(),
                  success: number(),
                  error_plaid: number(),
                  error_institution: number()
                }
        end
      end

      defmodule Auth do
        @moduledoc """
        Plaid Institution Auth Status data structure.
        """

        @derive Jason.Encoder
        defstruct status: nil, last_status_change: nil, breakdown: nil

        @type t :: %__MODULE__{
                status: String.t(),
                last_status_change: String.t(),
                breakdown: Plaid.Institutions.Institution.Status.Auth.Breakdown.t()
              }

        defmodule Breakdown do
          @moduledoc """
          Plaid Institution Auth Breakdown Status data structure.
          """

          @derive Jason.Encoder
          defstruct success: nil, error_plaid: nil, error_institution: nil

          @type t :: %__MODULE__{
                  success: number(),
                  error_plaid: number(),
                  error_institution: number()
                }
        end
      end

      defmodule Balance do
        @moduledoc """
        Plaid Institution Balance Status data structure.
        """

        @derive Jason.Encoder
        defstruct status: nil, last_status_change: nil, breakdown: nil

        @type t :: %__MODULE__{
                status: String.t(),
                last_status_change: String.t(),
                breakdown: Plaid.Institutions.Institution.Status.Balance.Breakdown.t()
              }

        defmodule Breakdown do
          @moduledoc """
          Plaid Institution Balance Breakdown Status data structure.
          """

          @derive Jason.Encoder
          defstruct success: nil, error_plaid: nil, error_institution: nil

          @type t :: %__MODULE__{
                  success: number(),
                  error_plaid: number(),
                  error_institution: number()
                }
        end
      end

      defmodule Identity do
        @moduledoc """
        Plaid Institution Identity Status data structure.
        """

        @derive Jason.Encoder
        defstruct status: nil, last_status_change: nil, breakdown: nil

        @type t :: %__MODULE__{
                status: String.t(),
                last_status_change: String.t(),
                breakdown: Plaid.Institutions.Institution.Status.Identity.Breakdown.t()
              }

        defmodule Breakdown do
          @moduledoc """
          Plaid Institution Identity Breakdown Status data structure.
          """

          @derive Jason.Encoder
          defstruct success: nil, error_plaid: nil, error_institution: nil

          @type t :: %__MODULE__{
                  success: number(),
                  error_plaid: number(),
                  error_institution: number()
                }
        end
      end
    end
  end

  @doc """
  Gets all institutions. Results paginated.

  Parameters
  ```
  %{count: 50, offset: 0}
  ```
  """
  @spec get(params, config) :: {:ok, Plaid.Institutions.t()} | error
  def get(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end

  @doc """
  Gets an institution by id.

  Parameters
  ```
  "ins_109512"

  OR

  %{institution_id: "ins_109512", options: %{include_optional_metadata: true, include_status: false}}
  ```
  """
  @spec get_by_id(String.t() | params, config) ::
          {:ok, Plaid.Institutions.Institution.t()} | error
  def get_by_id(params, config \\ %{}) do
    client = config[:client] || Plaid

    params = if is_binary(params), do: %{institution_id: params}, else: params

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/get_by_id", params, config)
      |> client.handle_response(:institution, config)
    end
  end

  @doc """
  Searches institutions by name and product.

  Parameters
  ```
  %{query: "Wells", products: ["transactions"], options: %{limit: 40, include_display_data: true}}
  ```
  """
  @spec search(params, config) :: {:ok, Plaid.Institutions.t()} | error
  def search(params, config \\ %{}) do
    client = config[:client] || Plaid

    if client.valid_credentials?(config) do
      :post
      |> client.make_request("#{@endpoint}/search", params, config)
      |> client.handle_response(@endpoint, config)
    end
  end
end
