defmodule TodoElixir.Project do
  use TodoElixir.Web, :model

  schema "projects" do
    field :name, :string
    has_many :tasks, TodoElixir.Task, on_delete: :delete_all

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 1)
  end
end
