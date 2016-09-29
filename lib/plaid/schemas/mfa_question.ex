defmodule Plaid.MfaQuestion do
  @moduledoc false

  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :access_token, :string
    embeds_many :mfa, Plaid.Question
    field :type, :string
  end
end

defmodule Plaid.Question do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :question, :string
  end
end
