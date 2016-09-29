defmodule Plaid.MfaMask do
  @moduledoc false

  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :access_token, :string
    embeds_many :mfa, Plaid.Mask
    field :type, :string
  end
end

defmodule Plaid.Mask do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :mask, :string
    field :type, :string
  end
end
