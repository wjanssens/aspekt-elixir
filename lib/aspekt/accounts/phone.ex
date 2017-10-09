defmodule Aspekt.Accounts.Phone do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Phone
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :number, :string
		field :label, :string
		field :status, :string
  end

	def changeset(%Phone{} = phone, attrs) do
		phone
		|> cast(attrs, [:mail, :label, :status])
		|> validate_required([:mail, :status])
		|> validate_inclusion(:label, ["mobile", "iphone", "home", "work", "main", "home fax", "work fax", "other fax", "pager", "other"])
		|> validate_inclusion(:status, ["unverified", "valid", "invalid"])
	end

  def to_principal(%Phone{} = phone) do
    %Principal{
      data: DN.to_string(%{mail: phone.mail, label: phone.label, status: phone.status}),
      hash: :crypto.hash(:sha512, phone.mail),
      kind: "phone"
    }
  end

end
