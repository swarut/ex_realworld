# ExRealworld

This is the example Elixir/Phoenix project that implements Realworld app (https://github.com/gothinkster/realworld) specification.

# Running
- Copy `.env.example` then rename it to `.env`
- Run `source .env` to load enviroment vars.
- Run `mix deps.get`
- Run `iex -S mix phx.server` to start the server.
- Run `mix test` to run the test suite.

# Validating Realworld specification
- Clone the original realworld app repo https://github.com/gothinkster/realworld.
- From api folder within the repo, run `APIURL=http://localhost:4000/api ./run-api-tests.sh`
