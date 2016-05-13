defmodule TodoElixir.Api.ProjectsController do
  use TodoElixir.Web, :controller

  def index(conn, _params) do
    projects = Repo.all(TodoElixir.Project)
    json(conn, %{projects: projects})
  end
end
