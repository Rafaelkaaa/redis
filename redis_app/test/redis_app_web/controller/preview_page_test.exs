defmodule RedisAppWeb.PreviewPageTest do
  use RedisAppWeb.ConnCase, async: true
  import Phoenix.LiveViewTest
  alias RedisApp.Cache

  setup do
    Cache.set("test_key", "test_value")
    on_exit(fn -> Cache.delete("test_key") end)
    conn = build_conn()
    {:ok, view, _html} = live(conn, "/")
    {:ok, view: view, conn: conn}
  end

  test "renders table with key-value pairs", %{view: view} do
    assert has_element?(view, "button", "Create 10 Key-Value pairs")

    assert has_element?(view, "#keys_values")

    for item <- Cache.list_keys_values() do
      assert has_element?(view, "td", item.key)
      assert has_element?(view, "td", item.value)
    end
  end

  test "creates a new key-value pair", %{view: view} do
    view |> element("button", "Create new") |> render_click()
    assert has_element?(view, "h2", "Create Form")

    view
    |> form("form", %{"key" => "new_key", "value" => "new_value"})
    |> render_submit()

    assert has_element?(view, "td", "new_key")
    assert has_element?(view, "td", "new_value")

    Cache.delete("new_key")
  end

  test "updates an existing key-value pair", %{view: view} do
    view |> element("button[phx-click=\"show_update\"][value=\"test_key\"]") |> render_click()
    assert has_element?(view, "h2", "Update Form")

    view
    |> form("form", %{"key" => "test_key", "value" => "updated_value"})
    |> render_submit()

    assert has_element?(view, "td", "test_key")
    assert has_element?(view, "td", "updated_value")

    Cache.set("test_key", "test_value")
  end

  test "deletes a key-value pair", %{conn: conn} do
    Cache.set("delete_key", "delete_value")

    {:ok, view, _html} = live(conn, "/")
    assert has_element?(view, "td", "delete_key")

    view |> element("button[phx-click=\"delete\"][value=\"delete_key\"]") |> render_click()

    refute has_element?(view, "td", "delete_key")
  end

  test "creates 10 random key-value pairs", %{view: view} do
    view |> element("button", "Create 10 Key-Value pairs") |> render_click()
    assert length(Cache.list_keys_values()) >= 10
  end
end
