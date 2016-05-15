defmodule TodoElixir.Api.TaskView do
  use TodoElixir.Web, :view

  def render("index.json", %{tasks: tasks}) do
    serialized_tasks = Enum.map(tasks, fn(task) ->
      serialize_task(task)
    end)
    %{tasks: serialized_tasks}
  end

  def render("show.json", %{task: task}) do
    %{task: serialize_task(task)}
  end

  defp serialize_task(task) do
    Map.take(task, [:id, :text, :project_id, :completed])
  end
end
