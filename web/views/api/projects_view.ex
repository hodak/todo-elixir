defmodule TodoElixir.Api.ProjectsView do
  use TodoElixir.Web, :view

  def render("index.json", %{projects: projects}) do
    serialized_projects = Enum.map(projects, &serialize_project/1)
    %{projects: serialized_projects}
  end

  def render("show.json", %{project: project}) do
    %{project: serialize_project(project)}
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    %{errors: errors}
  end

  defp serialize_project(project) do
    Map.take(project, [:id, :name])
  end
end
