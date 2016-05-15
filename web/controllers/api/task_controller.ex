defmodule TodoElixir.Api.TaskController do
  use TodoElixir.Web, :controller
  alias TodoElixir.{Project, Task}

  def index(conn, %{"project_id" => project_id}) do
    project = Repo.one from p in Project,
      where: p.id == ^project_id

    if project do
      tasks = Repo.all from t in Task,
        where: t.project_id == ^project.id,
        where: t.completed == false

      render(conn, "index.json", tasks: tasks)
    else
      send_resp(conn, 404, "")
    end
  end

  def create(conn, %{"project_id" => project_id, "task" => task_params}) do
    project = Repo.one from p in Project,
      where: p.id == ^project_id
    changeset = Task.changeset(%Task{project_id: project.id}, task_params)

    if changeset.valid? do
      task = Repo.insert!(changeset)
      render(conn, "show.json", task: task)
    else
      # pending
    end
  end
end
