defmodule Aspekt.Features.Node do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Features.Node


  schema "node" do
    field :abbr, :string
    field :complete_on, :date
    field :kind, :string
    field :name, :string
    field :owner_id, :integer
    field :parent_id, :integer
    field :percentage, :float
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(%Node{} = node, attrs) do
    node
    |> cast(attrs, [:parent_id, :owner_id, :kind, :name, :abbr, :complete_on, :percentage, :status])
    |> validate_required([:parent_id, :owner_id, :kind, :name, :abbr, :complete_on, :percentage, :status])
  end
end
