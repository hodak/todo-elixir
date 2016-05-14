defmodule TodoElixir.Api.ProjectsView do
  use TodoElixir.Web, :view

  def render("index.json", %{projects: projects}) do
    serialized_projects = for project <- projects do
      Map.take(project, [:id, :name])
    end

    %{projects: serialized_projects}
  end

  def render("show.json", %{project: project}) do
    %{project: Map.take(project, [:id, :name]) }
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    %{errors: errors}
  end
end
