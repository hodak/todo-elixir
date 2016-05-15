defmodule TodoElixir.Api.TaskView do
  use TodoElixir.Web, :view

  def render("index.json", %{tasks: tasks}) do
    serialized_tasks = Enum.map(tasks, fn(task) ->
      Map.take(task, [:id, :text, :project_id, :completed])
    end)
    %{tasks: serialized_tasks}
  end
end
