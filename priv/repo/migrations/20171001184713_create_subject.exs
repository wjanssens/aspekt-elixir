defmodule Aspekt.Repo.Migrations.CreateSubject do
  use Ecto.Migration

  def change do
    create table(:subject) do

      timestamps()
    end

  end
end
