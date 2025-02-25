defmodule Elasticsearch.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Elasticsearch.Blog` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        article: "some article",
        label: "some label",
        published: true,
        tag: "some tag"
      })
      |> Elasticsearch.Blog.create_post()

    post
  end
end
