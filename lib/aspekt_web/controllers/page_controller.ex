defmodule AspektWeb.PageController do
  use AspektWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
