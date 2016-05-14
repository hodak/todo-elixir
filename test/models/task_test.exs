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
end
