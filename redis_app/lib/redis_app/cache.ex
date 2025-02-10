defmodule RedisApp.Cache do
  @redis_config [host: "192.168.1.62", port: 6380]

  defp connect do
    case Redix.start_link(@redis_config) do
      {:ok, conn} -> {:ok, conn}
      {:error, reason} -> IO.inspect(reason, label: "Failed to connect to Redis")
    end
  end

  def set(key, value) do
    case connect() do
      {:ok, conn} ->
        case Redix.command(conn, ["SET", key, value]) do
          {:ok, reply} -> {:ok, reply}
          {:error, reason} -> IO.inspect(reason, label: "Redix error")
        end

      %Redix.ConnectionError{reason: :closed} ->
        {:error, "Failed to connect to Redis"}

      {:error, _reason} ->
        {:error, "Failed to connect to Redis"}
    end
  end
  def delete_all() do
    case connect() do
      {:ok, conn} ->
        case Redix.command(conn, ["FLUSHALL"]) do
          {:ok, reply} -> {:ok, reply}
          {:error, reason} -> IO.inspect(reason, label: "Redix error")
        end

      %Redix.ConnectionError{reason: :closed} ->
        {:error, "Failed to connect to Redis"}

      {:error, _reason} ->
        {:error, "Failed to connect to Redis"}
    end
  end

  def get(key) do
    case connect() do
      {:ok, conn} ->
        case Redix.command(conn, ["GET", key]) do
          {:ok, reply} -> reply
          {:error, reason} -> IO.inspect(reason, label: "Redix error")
        end

      %Redix.ConnectionError{reason: :closed} ->
        {:error, "Failed to connect to Redis"}

      {:error, _reason} ->
        {:error, "Failed to connect to Redis"}
    end
  end

  def delete(key) do
    case connect() do
      {:ok, conn} ->
        case Redix.command(conn, ["DEL", key]) do
          {:ok, 1} -> {:ok, "Key: #{key} deleted successfully"}
          {:ok, 0} -> {:error, "Key: #{key} not found"}
          {:error, reason} -> IO.inspect(reason, label: "Redix error")
        end

      %Redix.ConnectionError{reason: :closed} ->
        {:error, "Failed to connect to Redis"}

      {:error, _reason} ->
        {:error, "Failed to connect to Redis"}
    end
  end

  def list_keys_values() do
    [_, keys] = list_keys()

    keys
    |> Enum.map(fn key -> %{key: key, value: get(key)} end)
  end

  defp list_keys() do
    case connect() do
      {:ok, conn} ->
        case Redix.command(conn, ["SCAN", "0", "COUNT", "100"]) do
          {:ok, reply} -> reply
          {:error, reason} -> IO.inspect(reason, label: "Redix error")
        end

      %Redix.ConnectionError{reason: :closed} ->
        {:error, "Failed to connect to Redis"}

      {:error, _reason} ->
        {:error, "Failed to connect to Redis"}
    end
  end
end
