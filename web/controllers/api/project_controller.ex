defmodule TodoElixir.Api.ProjectController do
  use TodoElixir.Web, :controller
  alias TodoElixir.Project

  def index(conn, _params) do
    projects = Repo.all(Project)
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    changeset = Project.changeset(%Project{}, project_params)

    if changeset.valid? do
      project = Repo.insert!(changeset)
      render(conn, "show.json", project: project)
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project = Repo.one(from p in Project, where: p.id == ^id)
    if project do
      case Repo.delete(project) do
        {:ok, _} -> send_resp(conn, 200, "")
      end
    else
      send_resp(conn, 404, "")
    end
  end
end
