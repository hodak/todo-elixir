defmodule TodoElixir.Api.TaskController do
  use TodoElixir.Web, :controller
  alias TodoElixir.{Project, Task}

  def index(conn, %{"project_id" => project_id}) do
    case get_project(project_id) do
      nil -> send_resp(conn, 404, "")
      project ->
        tasks = Repo.all from t in Task,
          where: t.project_id == ^project.id,
          where: t.completed == false
        render(conn, "index.json", tasks: tasks)
    end
  end

  def create(conn, %{"project_id" => project_id, "task" => task_params}) do
    case get_project(project_id) do
      nil -> send_resp(conn, 404, "")
      project ->
        changeset = Task.changeset(%Task{}, Map.put(task_params, "project_id", project.id))

        if changeset.valid? do
          task = Repo.insert!(changeset)
          render(conn, "show.json", task: task)
        else
          conn
          |> put_status(:unprocessable_entity)
          |> render("error.json", changeset: changeset)
        end
    end
  end

  defp get_project(project_id) do
    Repo.one from p in Project, where: p.id == ^project_id
  end
end
