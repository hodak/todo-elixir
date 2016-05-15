defmodule TodoElixir.TaskTest do
  use TodoElixir.ModelCase

  alias TodoElixir.Task

  @valid_attrs %{completed: true, text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "it can be associated with a project" do
    project =
      TodoElixir.Project.changeset(%TodoElixir.Project{}, %{name: "Hodor"})
      |> Repo.insert!
    task =
      Task.changeset(%Task{}, %{text: "Hodor", project_id: project.id})
      |> Repo.insert!

    assert task.project_id == project.id
  end

  test "it must have text attribute" do
    changeset = Task.changeset(%Task{}, %{completed: true})
    refute changeset.valid?
  end

  test "it must have text attribute with minimum length 1" do
    changeset = Task.changeset(%Task{}, %{completed: true, text: ""})
    refute changeset.valid?
  end

  test "completed attribute can't be blank" do
    changeset = Task.changeset(%Task{}, %{completed: nil, text: "Hodor"})
    refute changeset.valid?
  end
end
