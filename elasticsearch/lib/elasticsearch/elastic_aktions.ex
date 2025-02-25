defmodule Elasticsearch.Elasticsearch do
  use Elasticsearch.Client, otp_app: :my_app

  def search(query) do
    query
    |> search("my_index")
  end
end

defmodule MyApp.Elasticsearch do
  def index_document(id, document) do
    Elasticsearch.Index.index("my_index", id, document)
  end
end
