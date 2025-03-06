defmodule Elasticsearch.ElasticsearchCluster do
  alias Elastix.{Index, Document, Search}
  alias Elasticsearch.Blog.Post
  alias Elasticsearch.Repo

  @url Application.compile_env(:elasticsearch, :url)
  @index Application.compile_env(:elasticsearch, :index)

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
          published_at: %{type: "date"}
        }
      }
    }

    Index.create(@url, @index, mapping)
  end

  def index_post(%Post{} = post) do
    Document.index(@url, @index, "_doc", post.id, Map.from_struct(post))
  end

  def get_post(id) do
    Document.get(@url, @index, "_doc", id)
  end

  def delete_post(id) do
    Document.delete(@url, @index, "_doc", id)
  end

  def get_posts_by_search(search_param) do
    %{
      query: %{
        bool: %{
          should: [
            %{wildcard: %{author: "*#{search_param}*"}},
            %{match_phrase_prefix: %{article: "*#{search_param}*"}}
          ]
        }
      },
      size: 50
    }
    |> validete_respons
  end

  def get_post_by_article(article) do
    %{
      query: %{
        bool: %{
          must: [
            %{match_phrase_prefix: %{article: "*#{article}*"}}
          ]
        }
      },
      size: 50
    }
    |> validete_respons
  end

  def get_all_documents do
    %{
      query: %{
        match_all: %{}
      },
      size: 50
    }
    |> validete_respons
  end

  def sync_posts_to_elasticsearch do
    Repo.all(Post)
    |> Enum.each(fn post ->
      index_post(post)
    end)
  end

  defp convert_jsone_to_post_struct(body) do
    case Jason.decode(body) do
      {:ok, %{"hits" => %{"hits" => hits}}} ->
        hits
        |> Enum.map(fn %{"_source" => source} ->
          struct(
            Elasticsearch.Blog.Post,
            Enum.into(source, %{}, fn
              {k, v} -> {String.to_atom(k), v}
            end)
          )
        end)

      {:ok, _} ->
        IO.inspect("Unexpected response structure", label: "Error")
        []

      {:error, reason} ->
        IO.inspect(reason, label: "Error decoding JSON")
        []
    end
  end

  defp validete_respons(query) do
    case Search.search(@url, @index, [], query) do
      {:ok, %{status_code: 200, body: body}} ->
        convert_jsone_to_post_struct(body)

      {:ok, %{status_code: status_code, body: body}} ->
        IO.inspect({status_code, body}, label: "Unexpected response")
        []

      {:error, reason} ->
        IO.inspect(reason, label: "Error fetching documents")
        []
    end
  end
end
