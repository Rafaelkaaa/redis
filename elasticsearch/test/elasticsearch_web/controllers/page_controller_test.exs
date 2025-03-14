defmodule ElasticsearchWeb.PageControllerTest do
  use ElasticsearchWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Blog\n</button>"
  end
end
