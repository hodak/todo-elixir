defmodule TodoElixir.Api.TaskControllerTest do
  use TodoElixir.ConnCase

  alias TodoElixir.{Project, Task}

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

  test "it doesn't return completed tasks" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    _completed_task =
      Ecto.build_assoc(project, :tasks, text: "Buy potatoes", completed: true)
      |> Repo.insert!
    pending_task =
      Ecto.build_assoc(project, :tasks, text: "Make potato pizza", completed: false)
      |> Repo.insert!
    conn = get conn, "/api/projects/#{project.id}/tasks"
    response = json_response(conn, 200)
    assert Enum.count(response["tasks"]) == 1
    assert Enum.at(response["tasks"], 0)["id"] == pending_task.id
  end

  test "it returns 404 when project with given id doesn't exist" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    conn = get conn, "/api/projects/#{project.id + 1}/tasks"
    assert conn.status == 404
  end

  # create
  test "it creates task for given project" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!

    conn = post conn, "/api/projects/#{project.id}/tasks", %{task: %{text: "Task"}}
    response = json_response(conn, 200)

    task = Repo.one(Task)
    assert task.text == "Task"
    assert task.completed == false
    assert task.project_id == project.id

    assert response["task"] == %{
      "id" => task.id,
      "project_id" => project.id,
      "text" => "Task",
      "completed" => false,
    }
  end

  test "it returns 404 for creation when project with given id doesn't exist" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    conn = post conn, "/api/projects/#{project.id + 1}/tasks", %{task: %{text: "Task"}}
    assert conn.status == 404
  end

  test "it doesn't create task when it is invalid" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    conn = post conn, "/api/projects/#{project.id}/tasks", %{task: %{text: ""}}
    response = json_response(conn, 422)
    assert response["errors"] == %{
      "text" => ["should be at least 1 character(s)"],
    }
  end

  test "it doesn't take id passed in task's param into consideration" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    task = Task.changeset(%Task{}, %{text: "Task"}) |> Repo.insert!
    conn = post conn, "/api/projects/#{project.id}/tasks", %{
      task: %{id: task.id, text: "Task"}
    }
    response = json_response(conn, 200)
    assert Repo.one(from t in Task, select: count(t.id)) == 2
    assert response["task"]["id"] != task.id
  end

  test "it doesn't take project_id passed in tasks's params into consideration" do
    project = Project.changeset(%Project{}, %{name: "Hodor"}) |> Repo.insert!
    other_project = Project.changeset(%Project{}, %{name: "Other P."}) |> Repo.insert!
    conn = post conn, "/api/projects/#{project.id}/tasks", %{
      task: %{project_id: other_project.id, text: "Task"}
    }
    response = json_response(conn, 200)
    assert response["task"]["project_id"] == project.id
  end
end
