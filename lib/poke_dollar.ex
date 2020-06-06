defmodule PokeDollar do
  use Application

  def start(_type, _args) do
    PokeDollar.Worker.start()
  end
end
