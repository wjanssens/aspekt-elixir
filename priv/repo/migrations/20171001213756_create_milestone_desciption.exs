defmodule Aspekt.Repo.Migrations.CreateMilestoneDescription do
  use Ecto.Migration

  def change do
    create table(:milestone_desc) do
      add :node_id, references(:node), null: false, comment: "the aspect milestone to which this definition applies"
      add :sequence, :integer, null: false
      add :name, :text, null: false
      add :effort, :integer, null: false

      timestamps()
    end

    create constraint(:milestone_desc, :effort_value, check: "effort between 1 and 100")

  end
end
