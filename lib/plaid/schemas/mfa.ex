defmodule Plaid.Mfa.Mask do
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
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :mask, :string
    field :type, :string
  end
end

defmodule Plaid.Mfa.Message do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :access_token, :string
    embeds_one :mfa, Plaid.Message
    field :type, :string
  end
end

defmodule Plaid.Mfa.Question do
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
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :question, :string
  end
end
