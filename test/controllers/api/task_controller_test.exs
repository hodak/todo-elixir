defmodule TodoElixir.Api.TaskControllerTest do
  use TodoElixir.ConnCase

  alias TodoElixir.{Project}

  # index
  test "it returns task that belongs to given project" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    task = Ecto.build_assoc(project, :tasks, text: "Task") |> Repo.insert!

    conn = get conn, "/api/projects/#{project.id}/tasks"
    response = json_response(conn, 200)

    assert Enum.count(response["tasks"]) == 1
    response_task = Enum.at(response["tasks"], 0)
    assert response_task == %{
      "id" => task.id,
      "project_id" => project.id,
      "text" => "Task",
      "completed" => false,
    }
  end

  test "it doesn't return tasks that belong to different project" do
    this_project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    these_task_ids = for task_text <- ["Task 1", "Task 2"] do
      Ecto.build_assoc(this_project, :tasks, text: task_text) |> Repo.insert! |> Map.fetch!(:id)
    end
    other_project = Project.changeset(%Project{}, %{name: "Other P."}) |> Repo.insert!
    for task_text <- ["Task 3", "Task 4"] do
      Ecto.build_assoc(other_project, :tasks, text: task_text) |> Repo.insert! |> Map.fetch!(:id)
    end

    conn = get conn, "/api/projects/#{this_project.id}/tasks"
    response = json_response(conn, 200)

    assert Enum.count(response["tasks"]) == 2
    assert Enum.map(response["tasks"], &(&1)["id"]) |> Enum.sort == these_task_ids |> Enum.sort
  end

  test "it returns empty collection when project doesn't have any tasks" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    conn = get conn, "/api/projects/#{project.id}/tasks"
    response = json_response(conn, 200)
    assert response["tasks"] == []
  end
end
