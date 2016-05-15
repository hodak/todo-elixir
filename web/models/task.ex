defmodule TodoElixir.Task do
  use TodoElixir.Web, :model

  schema "tasks" do
    field :text, :string
    field :completed, :boolean, default: false
    belongs_to :project, TodoElixir.Project

    timestamps
  end

  @required_fields ~w(text completed)
  @optional_fields ~w(project_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:text, min: 1)
  end
end
