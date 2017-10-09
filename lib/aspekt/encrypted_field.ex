defmodule Aspekt.EncryptedField do
  import Aspekt.AES

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    ciphertext = value |> to_string |> encrypt
    {:ok, ciphertext}
  end

  def load(value) do
		plaintext = decrypt(value)
    {:ok, plaintext}
  end
end
