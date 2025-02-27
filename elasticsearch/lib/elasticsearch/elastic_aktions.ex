defmodule Elasticsearch.ElasticsearchCluster do
  alias Elastix.{Index, Document, Search}
  alias Elasticsearch.Blog.Post

  @url Application.compile_env(:elasticsearch, :url)
  @index Application.compile_env(:elasticsearch, :index)

  @doc """
  Створює індекс у Elasticsearch.
  """
  def create_index do
    mapping = %{
      settings: %{
        index: %{number_of_shards: 1, number_of_replicas: 0}
      },
      mappings: %{
        properties: %{
          id: %{type: "integer"},
          label: %{type: "text"},
          tag: %{type: "text"},
          article: %{type: "text"},
          author: %{type: "text"},
          published: %{type: "boolean"},
          published_at: %{type: "date", format: "yyyy-MM-dd'T'HH:mm:ss"}
        }
      }
    }

    Index.create(@url, @index, mapping)
  end

  @doc """
  Додає пост до Elasticsearch.
  """
  def index_post(%Post{} = post) do
    Document.index(@url, @index, "_doc", post.id, Map.from_struct(post))
  end

  @doc """
  Отримує пост із Elasticsearch.
  """
  def get_post(id) do
    Document.get(@url, @index, "_doc", id)
  end

  @doc """
  Видаляє пост із Elasticsearch.
  """
  def delete_post(id) do
    Document.delete(@url, @index, "_doc", id)
  end

  def get_all_documents do
    query = %{
      query: %{
        match_all: %{}
      }
    }

    case Search.search(@url, @index, [], query) do
      {:ok, %{body: %{"hits" => %{"hits" => hits}}}} ->
        hits
        |> Enum.map(fn %{"_source" => source} ->
          struct(
            Elasticsearch.Blog.Post,
            Enum.into(source, %{}, fn {k, v} -> {String.to_existing_atom(k), v} end)
          )
        end)

      {:error, reason} ->
        IO.inspect(reason, label: "Error fetching documents")
        []
    end
  end
end
