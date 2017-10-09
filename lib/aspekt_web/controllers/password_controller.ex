defmodule AspektWeb.PasswordController do
  use AspektWeb, :controller
	alias Aspekt.Repo
	alias Aspekt.Accounts.Password

  def update(conn, params) do
		Password.delete_all(params.subject_id)

		changeset = Password.changeset(params)
		if changeset.valid? do
			changeset
			|> Ecto.Changeset.apply_changes
			|> Password.to_principal
			|> Repo.insert

			conn
			|> put_status(:created)
		end
  end
end
