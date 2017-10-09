defmodule Aspekt.Features.Remark do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Features.Remark


  schema "remark" do
    field :node_id, :integer
    field :subject_id, :integer
    field :value, :string

    timestamps()
  end

  @doc false
  def changeset(%Remark{} = remark, attrs) do
    remark
    |> cast(attrs, [:node_id, :subject_id, :value])
    |> validate_required([:node_id, :subject_id, :value])
  end
end
