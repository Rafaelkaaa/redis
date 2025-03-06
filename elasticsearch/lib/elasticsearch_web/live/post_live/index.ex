defmodule ElasticsearchWeb.PostLive.Index do
  use ElasticsearchWeb, :live_view

  alias Elasticsearch.Blog
  alias Elasticsearch.Blog.Post

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:search_filter, "")

    {:ok, stream(socket, :posts, Blog.list_posts())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Blog.get_post!(id))
    |> assign(:posts, Blog.list_posts())
  end

  defp apply_action(socket, :new, _params) do
    IO.inspect("apply_action(socket, :new, _params)")

    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
    |> assign(:posts, Blog.list_posts())
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
    |> assign(:posts, Blog.list_posts())
  end

  @impl true
  def handle_info({ElasticsearchWeb.PostLive.FormComponent, {:saved, post}}, socket) do
    {:noreply, stream_insert(socket, :posts, post)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Blog.delete_post(id)

    {:noreply, stream_delete(socket, :posts, post)}
  end

  @impl true
  def handle_event(
        "on_change_search",
        %{"search_filter" => search_filter},
        socket
      ) do
    posts = Blog.get_posts_by_search(search_filter)

    {:noreply, stream(socket, :posts, posts, reset: true)}
  end
end
