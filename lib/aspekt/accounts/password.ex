defmodule Aspekt.Accounts.Password do
  @config  Application.get_env(:aspekt, Aspekt.Accounts.Password)
  @options @config[:options]
  @algo    @config[:algorithm]

  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Aspekt.Repo
  alias Aspekt.Accounts.Password
  alias Aspekt.Accounts.Principal

  embedded_schema do
    field :password, :string
    field :subject_id, :integer
  end

  def delete_all(subject_id) do
    query = from p in "principal",
      where: p.type == "password" and p.subject_id == ^subject_id
    query |> Repo.delete_all
  end

  def changeset(attrs \\ %{}) do
		%Password{}
		|> cast(attrs, [:subject_id, :password])
		|> validate_required([:subject_id, :password])
	end

  def to_principal(%Password{} = password) do
    %Principal{
      data: hash(password.password),
      kind: "password",
      subject_id: password.subject_id,
      id: password.id
    }
  end

  def hash(plaintext, algo \\ @algo, opts \\ @options) do
    case algo do
      :ldap ->
        ldap(plaintext, opts)
      :pbkdf2 ->
        pbkdf2(plaintext, opts)
      :argon2 ->
        argon2(plaintext, opts)
      true ->
        bcrypt(plaintext, opts)
    end
  end

  def ldap(plaintext, opts) do
    digest = Map.get(opts, :digest, :sha512)
    salt_len = Map.get(opts, :salt_len, 16)
    salt = :crypto.strong_rand_bytes(salt_len)
    hash = :crypto.hash(digest, plaintext <> salt)
    scheme = "S" <> digest |> Atom.to_string
    "$#{scheme}$#{Base.encode64(salt)}$#{Base.encode64(hash)}"
  end

  def pbkdf2(plaintext, opts) do
    Pbkdf2.hash_pwd_salt(plaintext, opts)
  end

  def argon2(plaintext, opts) do
    Argon2.hash_pwd_salt(plaintext, opts)
  end

  def bcrypt(plaintext, opts) do
    Bcrypt.hash_pwd_salt(plaintext, opts)
  end

  def verify(plaintext, hash) do
    [ scheme | _rest ] = String.split(hash, ~r{\$})

    cond do
      Enum.member?(["smd5","ssha","ssha224","ssha256","ssha384","ssha512"], scheme) ->
        verify_ldap(plaintext, hash)
      Enum.member?(["argon2d","argon2i","argon2id"], scheme)
        verify_argon2(plaintext, hash)
      Enum.member?(["2a","2b"], scheme) ->
        verify_bcrypt(plaintext, hash)
      String.match?(scheme, ~r{pbkdf2-}) ->
        verify_pbkdf2(plaintext, hash)
      true ->
        false
    end
  end

  defp verify_ldap(plaintext, hash) do
    [ scheme, salt, hash ] = String.split(hash, ~r{\$})
    salt = Base.decode64(salt)
    digest = scheme |> String.slice(1..-1) |> String.to_atom
    hash == :crypto.hash(digest, plaintext <> salt)
  end

  defp verify_bcrypt(plaintext, hash) do
    Bcrypt.verify_pass(plaintext, hash)
  end

  defp verify_argon2(plaintext, hash) do
    Argon2.verify_pass(plaintext, hash)
  end

  defp verify_pbkdf2(plaintext, hash) do
    Pbkdf2.verify_pass(plaintext, hash)
  end

end
