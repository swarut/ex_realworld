defmodule ExRealworldWeb.Api.Auth do
  import Plug.Conn

  alias ExRealworld.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do

    token = get_req_header(conn, "authorization")
    case token do
      [] ->
        conn
      [token] ->
        case ExRealworldWeb.UserToken.decode_and_verify(token) do
          {:ok, claims} ->
            {:ok, resource} = ExRealworldWeb.UserToken.resource_from_claims(claims)
            {:ok, user} = Accounts.authenticate_with_email_and_token(resource.email, token)
            conn |> assign(:current_user, user)
          {:error, errors} ->
            IO.puts("ERRORS----  = #{inspect errors}")
            conn
        end
    end
  end

end
