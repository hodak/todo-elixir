defmodule TodoElixir.Project do
  use TodoElixir.Web, :model

  schema "projects" do
    field :name, :string

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
  end
end

defimpl Poison.Encoder, for: TodoElixir.Project do
  def encode(model, options) do
    model
    |> Map.take([:id, :name])
    |> Poison.Encoder.encode(options)
  end
end
