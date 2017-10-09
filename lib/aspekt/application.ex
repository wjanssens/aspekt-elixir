defmodule Aspekt.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Aspekt.Repo, []),
      # Start the endpoint when the application starts
      supervisor(AspektWeb.Endpoint, []),
      # Start your own worker by calling: Aspekt.Worker.start_link(arg1, arg2, arg3)
      # worker(Aspekt.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Aspekt.Supervisor]
    Supervisor.start_link(children, opts)

    << i1 :: unsigned-integer-32, i2 :: unsigned-integer-32, i3 :: unsigned-integer-32>> = :crypto.strong_rand_bytes(12)
    :rand.seed(:exsplus, {i1, i2, i3})
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AspektWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
