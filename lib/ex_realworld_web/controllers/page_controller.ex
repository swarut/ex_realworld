defmodule ExRealworldWeb.PageController do
  use ExRealworldWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
