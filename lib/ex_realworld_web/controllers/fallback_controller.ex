defmodule ExRealworldWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use ExRealworldWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ExRealworldWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid_token}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ExRealworldWeb.ErrorView)
    |> render(:"404")
  end
end
