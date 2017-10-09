defmodule Aspekt.Repo.Migrations.CreatePrincipal do
  use Ecto.Migration

  def change do
    create table(:principal) do
      add :subject_id, references(:subject), null: false
      add :kind, :string, size: 8, null: false
      add :sequence, :integer, default: 0
      add :hash, :string
      add :data, :binary, null: false

      timestamps()
    end

  end
end
