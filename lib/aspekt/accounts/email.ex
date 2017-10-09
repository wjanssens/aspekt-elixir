defmodule Aspekt.Accounts.Email do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Email
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :mail, :string
		field :label, :string
		field :status, :string
		field :sequence, :integer
    field :subject_id, :integer
  end

	def changeset(%Email{} = email, attrs) do
		email
		|> cast(attrs, [:subject_id, :sequence, :mail, :label, :status])
		|> validate_required([:subject_id, :mail, :status])
		|> validate_inclusion(:label, ["home", "work", "other"])
		|> validate_inclusion(:status, ["unverified", "valid", "invalid"])
	end

	def to_principal(%Email{} = email) do
    %Principal{
      data: DN.to_string(%{mail: email.mail, label: email.label, status: email.status}),
      hash: :crypto.hash(:sha512, email.mail),
      kind: "email",
			sequence: email.sequence,
			subject_id: email.subject_id,
			id: email.id
    }
  end

end
