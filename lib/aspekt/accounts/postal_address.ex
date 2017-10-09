defmodule Aspekt.Accounts.PostalAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.PostalAddress
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :lines, {:array, :string}
		field :label, :string
		field :status, :string
  end

	def changeset(%PostalAddress{} = address, attrs) do
		address
		|> cast(attrs, [:lines, :label, :status])
		|> validate_required([:lines, :status])
		|> validate_inclusion(:label, ["home", "work", "other"])
		|> validate_inclusion(:status, ["unverified", "valid", "invalid"])
	end

	def to_principal(%PostalAddress{} = address) do
		lines = address.lines
		|> Enum.map(fn l -> String.replace(l, "\\", "\\\\") end)
		|> Enum.map(fn l -> String.replace(l, "$", "\$") end)
		|> Enum.join("$")

    %Principal{
      data: DN.to_string(%{postalAddress: lines, label: address.label, status: address.status}),
      kind: "postal_address"
    }
  end

end
