defmodule Elasticsearch.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :label, :string
    field :tag, :string
    field :article, :string
    field :author, :string
    field :published, :boolean, default: false
    field :published_at, :utc_datetime, default: nil

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:article, :published, :tag, :label, :author, :published_at])
    |> validate_required([:article, :published, :tag, :label])
  end
end
