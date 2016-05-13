defmodule TodoElixir.Api.ProjectsControllerTest do
  use TodoElixir.ConnCase

  test "it returns empty array when there are no projects", %{conn: conn} do
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert response == %{"projects" => []}
  end

  test "it returns a project when such exists", %{conn: conn} do
    changeset = TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
    project = TodoElixir.Repo.insert!(changeset)
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert Enum.count(response["projects"]) == 1
    assert Enum.at(response["projects"], 0) == %{"id" => project.id, "name" => "Hodor"}
  end

  # TODO this spec tests ordering - it shouldn't, there should be a separate spec
  # specifying explicitly what the order should be, and that spec should fail when
  # order changes in the future
  test "it returns multiple projects when multiple exist", %{conn: conn} do
    hodor_project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"}) |>
      TodoElixir.Repo.insert!
    inbox_project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Inbox"}) |>
      TodoElixir.Repo.insert!
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert Enum.count(response["projects"]) == 2
    assert Enum.at(response["projects"], 0) == %{"id" => hodor_project.id, "name" => "Hodor"}
    assert Enum.at(response["projects"], 1) == %{"id" => inbox_project.id, "name" => "Inbox"}
  end
end
