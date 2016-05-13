defmodule TodoElixir.Api.ProjectsControllerTest do
  use TodoElixir.ConnCase

  test "it returns empty array when there are no projects", %{conn: conn} do
    conn = get conn, "/api/projects"
    response = json_response(conn, 200)
    assert response == %{"projects" => []}
  end
end
