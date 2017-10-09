defmodule Aspekt.Repo.Migrations.CreateNode do
  use Ecto.Migration

  def change do
    create table(:node) do
      add :parent_id, references(:node)
      add :owner_id, references(:subject)
      add :kind, :string, size: 8, null: false
      add :name, :string, size: 128, null: false
      add :abbr, :string, size: 8, null: false, comment: "subject prefix | activity initials | feature number"
      add :complete_on, :date
      add :percentage, :float
      add :status, :string, size: 16, null: false, default: "notstarted"

      timestamps()
    end

		create constraint(:node, :kind_enum, check: "kind in ('program','project','aspect','subject','activity','feature')")
		create constraint(:node, :status_enum, check: "status in ('notstarted','underway','attention','complete','inactive')")

  end
end
