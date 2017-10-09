defmodule Aspekt.Repo.Migrations.CreateParam do
  use Ecto.Migration

  def change do
    create table(:param) do
      add :name, :string, size: 32, null: false
      add :subject_id, :integer
      add :effective_at, :utc_datetime
      add :expires_at, :utc_datetime
      add :value, :text, null: false

      timestamps()
    end

  end
end
