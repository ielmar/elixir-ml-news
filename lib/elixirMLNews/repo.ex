defmodule ElixirMLNews.Repo do
  use Ecto.Repo,
    otp_app: :elixirMLNews,
    adapter: Ecto.Adapters.Postgres
end
