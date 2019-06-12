defmodule ExRealworldWeb.Api.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias ExRealworld.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    full_token = get_req_header(conn, "authorization")
    case full_token do
      [] ->
        conn
      ["Token " <> token ] ->
        case ExRealworldWeb.UserToken.decode_and_verify(token) do
          {:ok, claims} ->
            {:ok, resource} = ExRealworldWeb.UserToken.resource_from_claims(claims)
            {:ok, user} = Accounts.authenticate_with_email_and_token(resource.email, token)
            conn |> assign(:current_user, user)
          {:error, _errors} ->
            # IO.puts("ERRORS----  = #{inspect errors}")
            conn
        end
    end
  end

  def authenticate_user(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", error: "unauthorized")
        |> halt

      _user -> conn
    end
  end

end
