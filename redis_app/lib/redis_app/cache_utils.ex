defmodule RedisApp.CacheUtils do
  alias RedisApp.Cache
  alias Faker.Pokemon

  def create_10_random_key_value() do
    for _ <- 1..10 do
      Cache.set(Pokemon.name(), Pokemon.location())
    end
  end
end
