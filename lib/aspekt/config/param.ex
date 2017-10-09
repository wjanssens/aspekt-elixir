defmodule Aspekt.Config.Param do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Config.Param


  schema "param" do
    field :effective_at, :utc_datetime
    field :expires_at, :utc_datetime
    field :subject_id, :integer
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(%Param{} = param, attrs) do
    param
    |> cast(attrs, [:subject_id, :effective_at, :expires_at, :value])
    |> validate_required([:subject_id, :effective_at, :expires_at, :value])
  end
end
