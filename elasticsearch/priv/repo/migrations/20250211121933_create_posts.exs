defmodule Elasticsearch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :article, :string
      add :published, :boolean, default: false, null: false
      add :tag, :string
      add :label, :string
      add :author, :string
      add :published_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
