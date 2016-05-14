defmodule TodoElixir.Api.ProjectsController do
  use TodoElixir.Web, :controller
  alias TodoElixir.Project

  def index(conn, _params) do
    projects = Repo.all(Project)
    json(conn, %{projects: projects})
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)

    if changeset.valid? do
      project = Repo.insert!(changeset)
      json(conn, %{project: project})
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", changeset: changeset)
    end
  end
end
