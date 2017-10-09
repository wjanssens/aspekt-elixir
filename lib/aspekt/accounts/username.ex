defmodule Aspekt.Accounts.Username do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Username
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :username, :string
    field :subject_id, :integer
  end

	def changeset(%Username{} = username, attrs) do
		username
		|> cast(attrs, [:subject_id, :username])
		|> validate_required([:subject_id, :username])
	end

  def to_principal(%Username{} = username) do
    %Principal{
      data: DN.to_string(%{username: username.username}),
      hash: :crypto.hash(:sha512, username.username),
      kind: "username",
			sequence: nil,
			subject_id: username.subject_id,
			id: username.id
    }
  end

end
