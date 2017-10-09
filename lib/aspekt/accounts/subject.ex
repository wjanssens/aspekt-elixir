defmodule Aspekt.Accounts.Subject do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Subject

  schema "subject" do

    timestamps()
  end

  @doc false
  def changeset(%Subject{} = subject, attrs) do
    subject
    |> cast(attrs, [])
    |> validate_required([])
  end
end
