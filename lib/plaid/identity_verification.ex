defmodule Plaid.IdentityVerification do
  @moduledoc """
  Functions for Plaid `identity_verification` endpoint.

  [Plaid Identity Verification API Documentation](https://plaid.com/docs/api/products/identity-verification/)
  """

  alias Plaid.Client.Request
  alias Plaid.Client

  @derive Jason.Encoder
  defstruct id: nil,
            client_user_id: nil,
            created_at: nil,
            completed_at: nil,
            previous_attempt_id: nil,
            shareable_url: nil,
            status: nil,
            template: nil,
            user: nil,
            steps: nil,
            documentary_verification: nil,
            selfie_check: nil,
            kyc_check: nil,
            risk_check: nil,
            watchlist_screening: nil,
            request_id: nil

  @type t :: %__MODULE__{
          id: String.t(),
          client_user_id: String.t(),
          created_at: String.t(),
          completed_at: String.t() | nil,
          previous_attempt_id: String.t() | nil,
          shareable_url: String.t() | nil,
          status: String.t(),
          template: Plaid.IdentityVerification.Template.t(),
          user: Plaid.IdentityVerification.User.t(),
          steps: Plaid.IdentityVerification.Steps.t(),
          documentary_verification: Plaid.IdentityVerification.DocumentaryVerification.t() | nil,
          selfie_check: Plaid.IdentityVerification.SelfieCheck.t() | nil,
          kyc_check: Plaid.IdentityVerification.KYCCheck.t() | nil,
          risk_check: Plaid.IdentityVerification.RiskCheck.t() | nil,
          watchlist_screening: Plaid.IdentityVerification.WatchlistScreening.t() | nil,
          request_id: String.t()
        }
  @type params :: %{required(atom) => term}
  @type config :: %{required(atom) => String.t() | keyword}
  @type error :: {:error, Plaid.Error.t() | any()} | no_return

  defmodule Template do
    @moduledoc """
    Plaid Identity Verification Template data structure.
    """

    @derive Jason.Encoder
    defstruct id: nil, version: nil

    @type t :: %__MODULE__{
            id: String.t(),
            version: integer()
          }
  end

  defmodule User do
    @moduledoc """
    Plaid Identity Verification User data structure.
    """

    @derive Jason.Encoder
    defstruct email_address: nil,
              phone_number: nil,
              date_of_birth: nil,
              ip_address: nil,
              name: nil,
              address: nil,
              id_number: nil

    @type t :: %__MODULE__{
            email_address: String.t() | nil,
            phone_number: String.t() | nil,
            date_of_birth: String.t() | nil,
            ip_address: String.t() | nil,
            name: Plaid.IdentityVerification.User.Name.t() | nil,
            address: Plaid.IdentityVerification.User.Address.t() | nil,
            id_number: Plaid.IdentityVerification.User.IDNumber.t() | nil
          }

    defmodule Name do
      @moduledoc """
      Plaid Identity Verification User Name data structure.
      """

      @derive Jason.Encoder
      defstruct given_name: nil, family_name: nil

      @type t :: %__MODULE__{
              given_name: String.t(),
              family_name: String.t()
            }
    end

    defmodule Address do
      @moduledoc """
      Plaid Identity Verification User Address data structure.
      """

      @derive Jason.Encoder
      defstruct street: nil,
                street2: nil,
                city: nil,
                region: nil,
                postal_code: nil,
                country: nil

      @type t :: %__MODULE__{
              street: String.t(),
              street2: String.t() | nil,
              city: String.t(),
              region: String.t(),
              postal_code: String.t(),
              country: String.t()
            }
    end

    defmodule IDNumber do
      @moduledoc """
      Plaid Identity Verification User ID Number data structure.
      """

      @derive Jason.Encoder
      defstruct value: nil, type: nil

      @type t :: %__MODULE__{
              value: String.t(),
              type: String.t()
            }
    end
  end

  defmodule Steps do
    @moduledoc """
    Plaid Identity Verification Steps data structure.

    Each step will be one of the following values: `active`, `success`, `failed`,
    `waiting_for_prerequisite`, `not_applicable`, `skipped`, `expired`, `canceled`,
    `pending_review`, `manually_approved`, or `manually_rejected`.
    """

    @derive Jason.Encoder
    defstruct accept_tos: nil,
              verify_sms: nil,
              kyc_check: nil,
              documentary_verification: nil,
              selfie_check: nil,
              watchlist_screening: nil,
              risk_check: nil

    @type t :: %__MODULE__{
            accept_tos: String.t() | nil,
            verify_sms: String.t() | nil,
            kyc_check: String.t() | nil,
            documentary_verification: String.t() | nil,
            selfie_check: String.t() | nil,
            watchlist_screening: String.t() | nil,
            risk_check: String.t() | nil
          }
  end

  defmodule DocumentaryVerification do
    @moduledoc """
    Plaid Identity Verification Documentary Verification data structure.
    """

    @derive Jason.Encoder
    defstruct status: nil, documents: []

    @type t :: %__MODULE__{
            status: String.t(),
            documents: [Plaid.IdentityVerification.DocumentaryVerification.Document.t()]
          }

    defmodule Document do
      @moduledoc """
      Plaid Identity Verification Document data structure.
      """

      @derive Jason.Encoder
      defstruct status: nil,
                attempt: nil,
                images: [],
                extracted_data: nil,
                analysis: nil,
                redacted_images: []

      @type t :: %__MODULE__{
              status: String.t(),
              attempt: integer(),
              images: [Plaid.IdentityVerification.DocumentaryVerification.Document.Image.t()],
              extracted_data:
                Plaid.IdentityVerification.DocumentaryVerification.Document.ExtractedData.t()
                | nil,
              analysis:
                Plaid.IdentityVerification.DocumentaryVerification.Document.Analysis.t() | nil,
              redacted_images: [
                Plaid.IdentityVerification.DocumentaryVerification.Document.Image.t()
              ]
            }

      defmodule Image do
        @moduledoc """
        Plaid Identity Verification Document Image data structure.
        """

        @derive Jason.Encoder
        defstruct url: nil, capture_method: nil

        @type t :: %__MODULE__{
                url: String.t(),
                capture_method: String.t()
              }
      end

      defmodule ExtractedData do
        @moduledoc """
        Plaid Identity Verification Document Extracted Data data structure.
        """

        @derive Jason.Encoder
        defstruct date_of_birth: nil,
                  expiration_date: nil,
                  issued_date: nil,
                  issuing_country: nil,
                  id_number: nil,
                  category: nil,
                  address: nil,
                  name: nil

        @type t :: %__MODULE__{
                date_of_birth: String.t() | nil,
                expiration_date: String.t() | nil,
                issued_date: String.t() | nil,
                issuing_country: String.t() | nil,
                id_number: String.t() | nil,
                category: String.t() | nil,
                address: Plaid.IdentityVerification.User.Address.t() | nil,
                name: Plaid.IdentityVerification.User.Name.t() | nil
              }
      end

      defmodule Analysis do
        @moduledoc """
        Plaid Identity Verification Document Analysis data structure.
        """

        @derive Jason.Encoder
        defstruct authenticity: nil,
                  image_quality: nil,
                  extracted_data: nil

        @type t :: %__MODULE__{
                authenticity: String.t() | nil,
                image_quality: String.t() | nil,
                extracted_data: String.t() | nil
              }
      end
    end
  end

  defmodule SelfieCheck do
    @moduledoc """
    Plaid Identity Verification Selfie Check data structure.
    """

    @derive Jason.Encoder
    defstruct status: nil,
              attempt: nil,
              capture: [],
              analysis: nil

    @type t :: %__MODULE__{
            status: String.t(),
            attempt: integer(),
            capture: [Plaid.IdentityVerification.SelfieCheck.Capture.t()],
            analysis: Plaid.IdentityVerification.SelfieCheck.Analysis.t() | nil
          }

    defmodule Capture do
      @moduledoc """
      Plaid Identity Verification Selfie Capture data structure.
      """

      @derive Jason.Encoder
      defstruct url: nil, video_url: nil, capture_method: nil

      @type t :: %__MODULE__{
              url: String.t() | nil,
              video_url: String.t() | nil,
              capture_method: String.t()
            }
    end

    defmodule Analysis do
      @moduledoc """
      Plaid Identity Verification Selfie Analysis data structure.
      """

      @derive Jason.Encoder
      defstruct face_match: nil, image_quality: nil

      @type t :: %__MODULE__{
              face_match: String.t() | nil,
              image_quality: String.t() | nil
            }
    end
  end

  defmodule KYCCheck do
    @moduledoc """
    Plaid Identity Verification KYC Check data structure.
    """

    @derive Jason.Encoder
    defstruct status: nil,
              address: nil,
              name: nil,
              date_of_birth: nil,
              id_number: nil,
              phone_number: nil

    @type t :: %__MODULE__{
            status: String.t(),
            address: String.t() | nil,
            name: String.t() | nil,
            date_of_birth: String.t() | nil,
            id_number: String.t() | nil,
            phone_number: String.t() | nil
          }
  end

  defmodule RiskCheck do
    @moduledoc """
    Plaid Identity Verification Risk Check data structure.
    """

    @derive Jason.Encoder
    defstruct status: nil,
              risk_score: nil,
              linked_services: [],
              behavior: nil,
              email: nil,
              phone: nil

    @type t :: %__MODULE__{
            status: String.t(),
            risk_score: integer() | nil,
            linked_services: [String.t()],
            behavior: map() | nil,
            email: map() | nil,
            phone: map() | nil
          }
  end

  defmodule WatchlistScreening do
    @moduledoc """
    Plaid Identity Verification Watchlist Screening data structure.
    """

    @derive Jason.Encoder
    defstruct status: nil,
              audit_trail: nil,
              search_terms: nil

    @type t :: %__MODULE__{
            status: String.t(),
            audit_trail: String.t() | nil,
            search_terms: map() | nil
          }
  end

  defmodule Verifications do
    @moduledoc """
    Plaid Identity Verification List response data structure.
    """

    @derive Jason.Encoder
    defstruct identity_verifications: [],
              next_cursor: nil,
              request_id: nil

    @type t :: %__MODULE__{
            identity_verifications: [Plaid.IdentityVerification.t()],
            next_cursor: String.t() | nil,
            request_id: String.t()
          }
  end

  @doc """
  Creates a new Identity Verification.

  Parameters
  ```
  %{
    template_id: "idvtmp_4FrXJvfQU3zGUR",
    gave_consent: true,
    is_shareable: true,
    client_user_id: "your-db-id-3b24110",
    user: %{
      email_address: "user@example.com",
      phone_number: "+1 415 555 0100",
      date_of_birth: "1990-01-01",
      name: %{
        given_name: "John",
        family_name: "Doe"
      },
      address: %{
        street: "123 Main St",
        city: "San Francisco",
        region: "CA",
        postal_code: "94108",
        country: "US"
      }
    }
  }
  ```
  """
  @spec create(params, config) :: {:ok, Plaid.IdentityVerification.t()} | error
  def create(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "identity_verification/create", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_identity_verification(&1))
  end

  @doc """
  Retrieves the details of an Identity Verification.

  Parameters
  ```
  %{identity_verification_id: "idv_52xR9LKo77r1Np"}
  ```
  """
  @spec get(params, config) :: {:ok, Plaid.IdentityVerification.t()} | error
  def get(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "identity_verification/get", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_identity_verification(&1))
  end

  @doc """
  Lists Identity Verifications.

  Parameters
  ```
  %{
    template_id: "idvtmp_4FrXJvfQU3zGUR",
    client_user_id: "your-db-id-3b24110",
    cursor: "eyJkaXJlY3Rpb24iOiJuZXh0Iiwib2Zmc2V0IjoiMTU5NDM"
  }
  ```
  """
  @spec list(params, config) :: {:ok, Plaid.IdentityVerification.Verifications.t()} | error
  def list(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "identity_verification/list", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_verifications(&1))
  end

  @doc """
  Allows a user to retry an Identity Verification.

  Parameters
  ```
  %{
    client_user_id: "your-db-id-3b24110",
    template_id: "idvtmp_4FrXJvfQU3zGUR",
    strategy: "reset"
  }
  ```
  """
  @spec retry(params, config) :: {:ok, Plaid.IdentityVerification.t()} | error
  def retry(params, config \\ %{}) do
    c = config[:client] || Plaid

    Request
    |> struct(method: :post, endpoint: "identity_verification/retry", body: params)
    |> Request.add_metadata(config)
    |> c.send_request(Client.new(config))
    |> c.handle_response(&map_identity_verification(&1))
  end

  defp map_identity_verification(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.IdentityVerification{
          template: %Plaid.IdentityVerification.Template{},
          user: %Plaid.IdentityVerification.User{
            name: %Plaid.IdentityVerification.User.Name{},
            address: %Plaid.IdentityVerification.User.Address{},
            id_number: %Plaid.IdentityVerification.User.IDNumber{}
          },
          steps: %Plaid.IdentityVerification.Steps{},
          documentary_verification: %Plaid.IdentityVerification.DocumentaryVerification{
            documents: [
              %Plaid.IdentityVerification.DocumentaryVerification.Document{
                images: [%Plaid.IdentityVerification.DocumentaryVerification.Document.Image{}],
                redacted_images: [
                  %Plaid.IdentityVerification.DocumentaryVerification.Document.Image{}
                ],
                extracted_data:
                  %Plaid.IdentityVerification.DocumentaryVerification.Document.ExtractedData{
                    address: %Plaid.IdentityVerification.User.Address{},
                    name: %Plaid.IdentityVerification.User.Name{}
                  },
                analysis: %Plaid.IdentityVerification.DocumentaryVerification.Document.Analysis{}
              }
            ]
          },
          selfie_check: %Plaid.IdentityVerification.SelfieCheck{
            capture: [%Plaid.IdentityVerification.SelfieCheck.Capture{}],
            analysis: %Plaid.IdentityVerification.SelfieCheck.Analysis{}
          },
          kyc_check: %Plaid.IdentityVerification.KYCCheck{},
          risk_check: %Plaid.IdentityVerification.RiskCheck{},
          watchlist_screening: %Plaid.IdentityVerification.WatchlistScreening{}
        }
      }
    )
  end

  defp map_verifications(body) do
    Poison.Decode.transform(
      body,
      %{
        as: %Plaid.IdentityVerification.Verifications{
          identity_verifications: [
            %Plaid.IdentityVerification{
              template: %Plaid.IdentityVerification.Template{},
              user: %Plaid.IdentityVerification.User{
                name: %Plaid.IdentityVerification.User.Name{},
                address: %Plaid.IdentityVerification.User.Address{},
                id_number: %Plaid.IdentityVerification.User.IDNumber{}
              },
              steps: %Plaid.IdentityVerification.Steps{},
              documentary_verification: %Plaid.IdentityVerification.DocumentaryVerification{
                documents: [
                  %Plaid.IdentityVerification.DocumentaryVerification.Document{
                    images: [
                      %Plaid.IdentityVerification.DocumentaryVerification.Document.Image{}
                    ],
                    redacted_images: [
                      %Plaid.IdentityVerification.DocumentaryVerification.Document.Image{}
                    ],
                    extracted_data:
                      %Plaid.IdentityVerification.DocumentaryVerification.Document.ExtractedData{
                        address: %Plaid.IdentityVerification.User.Address{},
                        name: %Plaid.IdentityVerification.User.Name{}
                      },
                    analysis:
                      %Plaid.IdentityVerification.DocumentaryVerification.Document.Analysis{}
                  }
                ]
              },
              selfie_check: %Plaid.IdentityVerification.SelfieCheck{
                capture: [%Plaid.IdentityVerification.SelfieCheck.Capture{}],
                analysis: %Plaid.IdentityVerification.SelfieCheck.Analysis{}
              },
              kyc_check: %Plaid.IdentityVerification.KYCCheck{},
              risk_check: %Plaid.IdentityVerification.RiskCheck{},
              watchlist_screening: %Plaid.IdentityVerification.WatchlistScreening{}
            }
          ]
        }
      }
    )
  end
end
