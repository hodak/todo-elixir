defmodule TodoElixir.ProjectTest do
  use TodoElixir.ModelCase

  alias TodoElixir.Project

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "it has many tasks" do
    project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    task_ids = for task_text <- ["Buy potatoes", "Bake potato pizza"] do
      Ecto.build_assoc(project, :tasks, text: task_text)
      |> Repo.insert!
      |> Map.fetch!(:id)
    end
    project = Repo.preload(project, :tasks)
    assert Enum.count(project.tasks) == 2
    assert Enum.map(project.tasks, fn(task) -> task.id end) |> Enum.sort == task_ids |> Enum.sort
  end

  test "it removes tasks associated with a project when deleting a project" do
    project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    _task = Ecto.build_assoc(project, :tasks, text: "Task") |> Repo.insert!
    Repo.delete(project)
    assert Repo.one(from(t in TodoElixir.Task, select: count(t.id))) == 0
  end

  test "it doesn't remove tasks not associated with a project that's being deleted" do
    hodor_project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    other_project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Other"})
      |> Repo.insert!
    _hodor_task = Ecto.build_assoc(hodor_project, :tasks, text: "Hodor Task") |> Repo.insert!
    other_task = Ecto.build_assoc(other_project, :tasks, text: "Other Task") |> Repo.insert!
    Repo.delete(hodor_project)
    assert Repo.one(TodoElixir.Task) == other_task
  end
end
