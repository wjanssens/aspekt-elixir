defmodule Aspekt.Accounts.ChallengeResponse do
  use Ecto.Schema
  import Ecto.Changeset
  alias Aspekt.Accounts.ChallengeResponse
	alias Aspekt.Accounts.Principal
	alias Aspekt.DN

  embedded_schema do
    field :c, :string
		field :r, :string
		field :sequence, :integer
    field :subject_id, :integer
  end

	def changeset(%ChallengeResponse{} = cr, attrs) do
		cr
		|> cast(attrs, [:subject_id, :c, :r])
		|> validate_required([:subject_id, :c, :r])
	end

	def to_principal(%ChallengeResponse{} = cr) do
    %Principal{
      data: DN.to_string(cr),
      kind: "challenge_response",
			sequence: cr.sequence,
			subject_id: cr.subject_id,
			id: cr.id
    }
  end

end
