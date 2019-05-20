defmodule ExRealworldWeb.Api.Auth do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    token = get_req_header(conn, "authorization")
    case token do
      [] -> ""
      [token] ->
        IO.puts("AUTH - token = '#{token}'")
        case ExRealworldWeb.UserToken.decode_and_verify(token) do
          {:ok, claims} -> IO.puts("CLAIMS----  = #{inspect claims}")
          {:error, errors} -> IO.puts("ERRORS----  = #{inspect errors}")
        end
    end

    IO.puts("CONN PARAM = #{inspect conn.params}")
    conn
  end

end
