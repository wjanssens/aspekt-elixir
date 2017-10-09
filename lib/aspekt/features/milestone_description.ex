defmodule Aspekt.Features.MilestoneDescription do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Features.MilestoneDescription


  schema "milestone_description" do
    field :effort, :integer
    field :name, :string
    field :node_id, :integer
    field :sequence, :integer

    timestamps()
  end

  @doc false
  def changeset(%MilestoneDescription{} = milestone_description, attrs) do
    milestone_description
    |> cast(attrs, [:node_id, :sequence, :name, :effort])
    |> validate_required([:node_id, :sequence, :name, :effort])
  end
end
