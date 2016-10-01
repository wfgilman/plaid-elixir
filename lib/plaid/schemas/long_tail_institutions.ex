defmodule Plaid.LongTailInstitutions do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :id, :string
    field :name, :string
    embeds_one :products, Plaid.LongTailInstitutions.Products
    field :forgottenPassword, :string
    field :accountLocked, :string
    field :accountSetup, :string
    embeds_many :fields, Plaid.LongTailInstitutions.Fields
    field :type, :string
  end
end

defmodule Plaid.LongTailInstitutions.Products do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :auth, :string
    field :connect, :string
    field :balance, :string
    field :info, :string
    field :risk, :string
    field :income, :string
  end
end

defmodule Plaid.LongTailInstitutions.Fields do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :name, :string
    field :label, :string
    field :type, :string
  end
end
