defmodule Plaid.MfaMessage do
  @moduledoc false

  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :access_token, :string
    embeds_one :mfa, Plaid.Message
    field :type, :string
  end
end
