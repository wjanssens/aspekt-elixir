defmodule Aspekt.Accounts.Totp do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.Totp
	alias Aspekt.Accounts.Principal

  embedded_schema do
    field :secret_key, :binary
		field :scratch_codes, {:array, :integer}
    field :subject_id, :integer
  end

	def changeset(%Totp{} = totp, attrs) do
    totp
    |> cast(attrs, [:subject_id, :secret_key, :scratch_codes])
    |> validate_required([:subject_id, :secret_key, :scratch_codes])
  end

  def to_principal(%Totp{} = totp) do
    %Principal{
      data: "#{Base.encode32(totp.secret_key)};#{Enum.join(totp.scratch_codes,",")}",
      kind: "totp",
			sequence: nil,
			subject_id: totp.subject_id,
			id: totp.id
    }
  end

	def new() do
		%Totp{
			secret_key: :crypto.strong_rand_bytes(10),
			scratch_codes: Enum.map(1..10, fn _v -> Enum.random(1_000_000..9_999_999) end)
		}
	end

	def new(str) do
		[ secret, scratch_codes ] = String.split(str, ";")
		%Totp{
			secret_key: Base.decode32(secret),
			scratch_codes: scratch_codes |> String.split(",") |> Enum.map(&String.to_integer/1)
		}
	end

	def uri(secret_key, issuer, uid) do
		secret = Base.encode32(secret_key)
		"otpauth://totp/#{issuer}:#{uid}?secret=#{secret}&issuer=#{issuer}&algorithm=sha1&digits=6&period=30"
	end

end
