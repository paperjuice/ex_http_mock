defmodule ExHttpMock.Application do
  @moduledoc false

  alias ExHttpMock.API

  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: API, options: [port: 9997]},
      {ExHttpMock.State, %{}}
    ]

    Application.get_env(:ex_http_mock, :mock_path)

    opts = [strategy: :one_for_one, name: ExHttpMock.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
