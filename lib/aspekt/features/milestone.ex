defmodule Aspekt.Features.Milestone do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Features.Milestone


  schema "milestone" do
    field :actual, :date
    field :node_id, :integer
    field :planned, :date
    field :sequence, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(%Milestone{} = milestone, attrs) do
    milestone
    |> cast(attrs, [:node_id, :sequence, :planned, :actual, :status])
    |> validate_required([:node_id, :sequence, :planned, :actual, :status])
  end
end
