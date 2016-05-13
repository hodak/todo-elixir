defmodule TodoElixir.PageController do
  use TodoElixir.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
