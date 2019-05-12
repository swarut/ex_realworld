defmodule ExRealworld.Repo do
  use Ecto.Repo,
    otp_app: :ex_realworld,
    adapter: Ecto.Adapters.Postgres
end
