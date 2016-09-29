defmodule Plaid.Transaction do
  @moduledoc false

  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :_account, :string
    field :_id, :string
    field :amount, :decimal
    field :date, :string # Ecto.Date
    field :name, :string
    embeds_one :meta, Plaid.TransactionMeta
    field :pending, :boolean
    embeds_one :type, Plaid.TransactionType
    field :category, {:array, :string}
    field :category_id, :string
    embeds_one :score, Plaid.TransactionScore
  end
end

defmodule Plaid.TransactionMeta do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    embeds_one :location, Plaid.TransactionMetaLocation
    field :contact, :string
  end
end

defmodule Plaid.TransactionMetaLocation do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :address, :string
    field :city, :string
    embeds_one :coordinates, Plaid.TransactionMetaLocationCoordinates
    field :state, :string
    field :store_number, :string
    field :zip, :string
  end
end

defmodule Plaid.TransactionMetaLocationCoordinates do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :lat, :float
    field :lon, :float
  end
end

defmodule Plaid.TransactionType do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :primary, :string
  end
end

defmodule Plaid.TransactionScore do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    embeds_one :location, Plaid.TransactionScoreLocation
    field :name, :float
  end
end

defmodule Plaid.TransactionScoreLocation do
  use Ecto.Schema

  @primary_key false

  embedded_schema do
    field :address, :float
    field :city, :float
    field :state, :float
    field :zip, :float
  end
end
