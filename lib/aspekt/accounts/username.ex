defmodule Aspekt.Accounts.Username do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Username
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :username, :string
  end

	def changeset(%Username{} = username, attrs) do
		username
		|> cast(attrs, [:username])
		|> validate_required([:username])
	end

  def to_principal(%Username{} = username) do
    %Principal{
      data: DN.to_string(%{username: username.username}),
      hash: :crypto.hash(:sha512, username.username),
      kind: "username"
    }
  end

end
