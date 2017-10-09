defmodule Aspekt.Repo.Migrations.CreateRemark do
  use Ecto.Migration

  def change do
    create table(:remark) do
      add :node_id, references(:node), null: false, comment: "the node to which the remark applies"
      add :subject_id, references(:subject), null: false, comment: "the author of the remark"
      add :value, :text, null: false, comment: "markdown annotated text"

      timestamps()
    end

  end
end
