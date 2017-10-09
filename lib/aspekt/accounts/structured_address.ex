defmodule Aspekt.Accounts.StructuredAddress do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.StructuredAddress
  alias Aspekt.Accounts.Principal
  alias Aspekt.DN

  embedded_schema do
    field :title, :string
    field :gn, :string #given name
    field :initials, :string
    field :sn, :string #surname
    field :o, :string #organization
    field :ou, :string #organizational unit
    field :street, :string
    field :po, :string # post office box, post town, neighborhood
    field :l, :string #locality, si
    field :st, :string #state, province, prefecture, do
    field :pc, :string # postal code
    field :c, :string #country
		field :label, :string
		field :status, :string
  end

	def changeset(%StructuredAddress{} = address, attrs) do
		address
		|> cast(attrs, [:lines, :label, :status])
		|> validate_required([:street, :l, :pc, :c, :status])
		|> validate_inclusion(:label, ["home", "work", "other"])
		|> validate_inclusion(:status, ["unverified", "valid", "invalid"])
	end

	def to_principal(%StructuredAddress{} = address) do
		%Principal{
      data: DN.to_string(address),
      kind: "full_address"
    }
  end

  def format(%StructuredAddress{} = a, origin_country) do
    # TODO add more formats

    c = a.c
    same = a.c == origin_country
    country = if same, do: nil, else: a.c # TODO need to format the country name

    north_america = Enum.member?(["AU","CA","PR","US"], c)
    south_america = Enum.member?(["AR","EC","CL","CO","PE","VE"], c)
    korea = Enum.member?(["KP","KR"], c)


    formatted = fn
      a when north_america ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{a.st} #{a.pc}\n#{country}"

      a when south_america ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{a.st}\n#{country}"

      a when "MX" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}, #{a.st}\n#{country}"
      a when "BR" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.l} - #{a.st}\n#{a.pc}\n#{country}"

      # western europe
      a when "AU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.pc} #{String.upcase(a.l)}\n#{country}"
      a when "BE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"
      a when "CH" == c ->
        "#{a.title} #{a.gn} #{a.sn}\n#{a.street}\n#{a.pc} #{a.l}\n#{country}"
      a when "CZ" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"
      a when "DE" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"
      a when "DK" == c ->
        prefix = if same, do: "", else: "DK-"
        "#{a.title} #{a.gn} #{a.initals} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{a.l}\n#{country}"
      a when "FI" == c ->
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"
      a when "FR" == c ->
        prefix = if same, do: "", else: "FR-"
        surname = a.sn |> String.upcase
        "#{a.o}\n#{a.title} #{a.gn} #{a.initials} #{surname}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{a.l}\n#{country}"
      a when "HU" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.l}\n#{a.street}\n#{a.pc}\n#{country}"
      a when "IT" == c ->
        prefix = if same, do: "", else: "IT-"
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{prefix}#{a.pc} #{a.l} #{a.st}\n#{country}"
      a when "NL" == c ->
        "#{a.o}\n#{a.ou}\n#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.st} #{a.l}\n#{country}"
      a when "NO" == c ->
        "#{a.o}\n#{a.street}\n#{a.gn} #{a.sn}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"
      a when "PT" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}\n#{a.pc}\n#{country}"
      a when "SE" == c ->
        "#{a.o}\n#{a.gn} #{a.sn}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{country}"

      # british isles
      a when "GB" == c ->
        post_town = String.upcase(a.po)
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.l}\n#{post_town}\n#{a.pc}\n#{country}"

      # asia
      a when korea ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l} #{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"

      a when "CN" == c ->
        "#{country}\n#{a.st} #{a.l}\n#{a.street}\n#{a.sn} #{a.gn} #{a.title}"
      a when "JP" == c ->
        "#{country}\n#{a.pc} #{a.st} #{a.l}\n#{a.street}\n#{a.o}\n#{a.sn} #{a.gn} #{a.title}"
      a when "MY" == c ->
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.pc} #{a.l}\n#{a.st} #{country}"

      # slavic
      a when "BG" == c ->
        "#{country}\n#{a.st}\n#{a.pc} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.title} #{a.gn} #{a.initals} #{a.sn}"
      a when "RU" == c ->
        "#{country}\n#{a.pc}\n#{a.st} #{a.l}\n#{a.street}\n#{a.po}\n#{a.o}\n#{a.sn} #{a.gn} #{a.initials}"

      a -> # international format
        "#{a.title} #{a.gn} #{a.initials} #{a.sn}\n#{a.ou}\n#{a.o}\n#{a.street}\n#{a.po}\n#{a.l}, #{a.st} #{a.pc}\n#{country}"
    end

    formatted.(a)
    |> String.replace(~r{^\s*}, "") # remove extra space at start of line
    |> String.replace(~r{\s+}, " ") # remove duplicate spaces
    |> String.replace(~r{\n+}, "\n") # remove empty lines
    |> String.replace("\x1f", "\n") # insert required empty lines
  end

end
