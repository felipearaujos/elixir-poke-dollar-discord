use Mix.Config

config :nostrum,
  token: System.get_env("POKE_DOLLAR_BOT_TOKEN"),
  num_shards: :auto
