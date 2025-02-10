defmodule RedisApp.CacheTest do
  use ExUnit.Case, async: true

  alias RedisApp.Cache

  setup do
    {:ok, _} = Cache.set("test_key", "test_value")
    :ok
  end

  test "set and get a key" do
    assert {:ok, "OK"} = Cache.set("foo", "bar")
    assert "bar" = Cache.get("foo")
  end

  test "get a non-existent key" do
    assert Cache.get("non_existent") == nil
  end

  test "delete an existing key" do
    assert {:ok, "OK"} = Cache.set("to_delete", "value")
    assert {:ok, "Key: to_delete deleted successfully"} = Cache.delete("to_delete")
    assert Cache.get("to_delete") == nil
  end

  test "delete a non-existent key" do
    assert {:error, "Key: missing_key not found"} = Cache.delete("missing_key")
  end

  test "list keys and values" do
    Cache.set("key1", "value1")
    Cache.set("key2", "value2")

    keys_values = Cache.list_keys_values()
    expected_keys = ["test_key", "key1", "key2"]

    for %{key: key, value: value} <- expected_keys do
      assert key in keys_values
      assert value == Cache.get(key)
    end
  end
end
