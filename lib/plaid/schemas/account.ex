defmodule Plaid.Account do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :_id, :string
    field :_item, :string
    field :_user, :string
    embeds_one :balance, Plaid.AccountBalance
    field :institution_type, :string
    embeds_one :meta, Plaid.AccountMeta
    field :subtype, :string
    field :type, :string
  end
end

defmodule Plaid.Account.Balance do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :available, :float
    field :current, :float
  end
end

defmodule Plaid.Account.Meta do
  @moduledoc false
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :limit, :integer
    field :name, :string
    field :number, :string
    field :official_name, :string
  end
end
