defmodule TodoElixir.Api.ProjectControllerTest do
  use TodoElixir.ConnCase

  # index
  test "it returns empty array when there are no projects", %{conn: conn} do
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert response == %{"projects" => []}
  end

  test "it returns a project when such exists", %{conn: conn} do
    changeset = TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
    project = Repo.insert!(changeset)
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
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    inbox_project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Inbox"})
      |> Repo.insert!
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert Enum.count(response["projects"]) == 2
    assert Enum.at(response["projects"], 0) == %{"id" => hodor_project.id, "name" => "Hodor"}
    assert Enum.at(response["projects"], 1) == %{"id" => inbox_project.id, "name" => "Inbox"}
  end

  # create
  test "it creates a project when params are valid and returns this project", %{conn: conn} do
    conn = post conn, "/api/projects", %{project: %{name: "Hodor"}}
    response = json_response(conn, 200)
    new_project = Repo.one(TodoElixir.Project)
    assert response["project"]["id"] == new_project.id
    assert response["project"]["name"] == "Hodor"
  end

  test "it doesn't create a project when it is invalid", %{conn: conn} do
    conn = post conn, "/api/projects", %{project: %{name: ""}}
    response = json_response(conn, 422)
    assert response["errors"] == %{"name" => ["should be at least 1 character(s)"]}
  end

  # delete
  test "it deletes project" do
    project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    conn = delete conn, "/api/projects/#{project.id}"
    assert conn.status == 200
    assert conn.resp_body == ""
    assert Repo.one(from p in TodoElixir.Project, select: count(p.id)) == 0
  end

  test "it returns 404 when project with given id doesn't exist" do
    project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    conn = delete conn, "/api/projects/#{project.id + 1}"
    assert conn.status == 404
    assert conn.resp_body == ""
    assert Repo.one(from p in TodoElixir.Project, select: count(p.id)) == 1
  end
end
