import Ecto.Query

defmodule AspektWeb.Api.SubjectController do
	use AspektWeb, :controller
	alias Aspekt.Accounts.Subject

	def index(conn, _params) do
    json conn, Aspekt.Repo.all(from s in Subject, select: s.id)
  end

end
