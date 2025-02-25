defmodule Elasticsearch.BlogTest do
  use Elasticsearch.DataCase

  alias Elasticsearch.Blog

  describe "posts" do
    alias Elasticsearch.Blog.Post

    import Elasticsearch.BlogFixtures

    @invalid_attrs %{label: nil, tag: nil, article: nil, published: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{label: "some label", tag: "some tag", article: "some article", published: true}

      assert {:ok, %Post{} = post} = Blog.create_post(valid_attrs)
      assert post.label == "some label"
      assert post.tag == "some tag"
      assert post.article == "some article"
      assert post.published == true
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{label: "some updated label", tag: "some updated tag", article: "some updated article", published: false}

      assert {:ok, %Post{} = post} = Blog.update_post(post, update_attrs)
      assert post.label == "some updated label"
      assert post.tag == "some updated tag"
      assert post.article == "some updated article"
      assert post.published == false
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, @invalid_attrs)
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end
end
