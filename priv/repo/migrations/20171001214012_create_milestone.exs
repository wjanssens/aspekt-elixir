defmodule Aspekt.Repo.Migrations.CreateMilestones do
  use Ecto.Migration

  def change do
    create table(:milestone) do
      add :node_id, references(:node), null: false, comment: "the feature node that the milestone applies to"
      add :milestone_desc_id, references(:milestone_desc), null: false, comment: "the milestone description that this milestone applies to"
      add :planned, :date
      add :actual, :date
      add :status, :string, size: 8, null: false, default: "notstarted"

      timestamps()
    end

		create constraint(:milestone, :status_enum, check: "status in ('notstarted','underway','attention','complete','inactive')")

  end
end
