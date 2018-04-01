defmodule RandomReader.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(RandomReader.Repo, []),
      # Start the endpoint when the application starts
      supervisor(RandomReader.Web.Endpoint, []),
      worker(RandomReader.Schedule, [])
      # Start your own worker by calling: RandomReader.Worker.start_link(arg1, arg2, arg3)
      # worker(RandomReader.Worker, [arg1, arg2, arg3]),
    ]

    opts = [strategy: :one_for_one, name: RandomReader.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
