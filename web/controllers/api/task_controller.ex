defmodule TodoElixir.Api.TaskController do
  use TodoElixir.Web, :controller
  alias TodoElixir.{Project, Task}

  def index(conn, %{"project_id" => project_id}) do
    project =
      from(p in Project, where: p.id == ^project_id, preload: [:tasks])
      |> Repo.one
    render(conn, "index.json", tasks: project.tasks)
  end
end
