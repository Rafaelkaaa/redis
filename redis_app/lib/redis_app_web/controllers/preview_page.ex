defmodule RedisAppWeb.PreviewPage do
  use RedisAppWeb, :live_view

  alias RedisApp.Cache
  alias RedisApp.CacheUtils

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(show_update: false)
     |> assign(show_create: false)
     |> assign_keys_values
     |> assign(form: to_form(%{"key" => "", "value" => ""}))}
  end

  def handle_event("create_10", _params, socket) do
    CacheUtils.create_10_random_key_value()
    {:noreply, assign_keys_values(socket)}
  end

  def handle_event("show_create", _params, socket) do
    {:noreply,
     socket
     |> assign(show_create: true)
     |> assign(show_update: false)}
  end

  def handle_event("cancel_create", _params, socket) do
    {:noreply,
     socket
     |> assign(show_create: false)}
  end

  def handle_event("show_update", %{"value" => key}, socket) do
    {:noreply,
     socket
     |> assign(show_update: true)
     |> assign(show_create: false)
     |> assign_form(key)}
  end

  def handle_event("cancel_update", _params, socket) do
    {:noreply,
     socket
     |> assign(show_update: false)}
  end

  def handle_event("create", %{"key" => key, "value" => value}, socket) do
    Cache.set(key, value)

    {:noreply,
     assign_keys_values(socket)
     |> assign(show_create: false)}
  end

  def handle_event("update", %{"key" => key, "value" => value}, socket) do
    Cache.set(key, value)

    {:noreply,
     assign_keys_values(socket)
     |> assign(show_update: false)}
  end

  def handle_event("delete", %{"value" => key}, socket) do
    Cache.delete(key)
    {:noreply, assign_keys_values(socket)}
  end

  defp assign_keys_values(socket) do
    socket
    |> assign(list_keys_values: Cache.list_keys_values())
  end

  defp assign_form(socket, key) do
    socket
    |> assign(form: to_form(%{"key" => key, "value" => Cache.get(key)}))
  end
end
