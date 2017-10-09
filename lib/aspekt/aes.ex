defmodule Aspekt.AES do

	@config  Application.get_env(:aspekt, Aspekt.AES)
	@keys    @config[:keys]
	@key_id @config[:default_key_id]

  def encrypt(plaintext, key_id \\ @key_id) do
		tag_len = 16 # 128-bit random tag
		aad = ""
		key = @keys[key_id]
		iv    = :crypto.strong_rand_bytes(12) # 96-bit random IVs for each encryption

		{ ciphertext, tag } = :crypto.block_encrypt(:aes_gcm, key, iv, {aad, plaintext, tag_len})
    key_id <> iv <> tag <> ciphertext
  end

  def decrypt(ciphertext) do
    <<key_id::binary-1, iv::binary-12, tag::binary-16, ciphertext::binary>> = ciphertext
		key = @keys[key_id]
		aad = ""
		:crypto.block_decrypt(:aes_gcm, key, iv, {aad, ciphertext, tag})
  end

end
