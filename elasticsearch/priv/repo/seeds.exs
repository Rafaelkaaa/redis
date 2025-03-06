alias Faker.{Person, Company, Lorem}
alias Elasticsearch.Blog

for _ <- 1..10 do
  Blog.create_post(%{
    "label" => Person.suffix(),
    "article" => Lorem.paragraph(2..3),
    "author" => Person.name(),
    "tag" => Company.name(),
    "published" => Enum.random([true, false]),
    "published_at" => DateTime.utc_now()
  })
end
