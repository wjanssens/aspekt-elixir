defmodule Aspekt.Accounts.Principal do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Principal

  schema "principal" do
    field :data, Aspekt.EncryptedField
    field :hash, :string
    field :kind, :string
    field :sequence, :integer
    field :subject_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%Principal{} = principal, attrs) do
    principal
    |> cast(attrs, [:subject_id, :kind, :sequence, :hash, :data])
    |> validate_required([:subject_id, :kind, :sequence, :hash, :data])
  end
end
