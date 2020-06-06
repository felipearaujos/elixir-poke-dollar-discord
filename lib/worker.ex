defmodule PokeDollar.Worker do
  use Nostrum.Consumer

  alias Nostrum.Api

  def start_link() do
    start()
  end

  def start() do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    case msg.content do
      "!dollar" ->
        Api.create_message(msg.channel_id, get_dollar().real)

      "!ping" ->
        Api.create_message(msg.channel_id, "pong!")

      "!poke_dollar" ->
        poke_dollar = get_poke
        message = "O Pokedollar está em #{poke_dollar.real}, Pokemon: #{poke_dollar.poke}"
        Api.create_message(msg.channel_id, message)

      "!help" ->
        Api.create_message(msg.channel_id, "Pika")

      "!raise" ->
        # This won't crash the entire Consumer.
        raise "No problems here!"

      _ ->
        :ignore
    end
  end

  # Default event handler
  def handle_event(_event) do
    :noop
  end

  def get_dollar() do
    formatted =
      HTTPoison.get!(
        "http://cotacoes.economia.uol.com.br/cambioJSONChart.html?type=d&cod=BRL&mt=off"
      ).body
      |> Poison.Parser.parse!()
      |> Enum.at(1)
      |> Enum.at(-1)
      |> extract_dollar()
      |> to_poke_response()
  end

  def to_poke_response(formatted) do
    %{
      poke_id: String.to_integer(String.replace(formatted, ".", "")),
      real: "R$ #{String.replace(formatted, ".", ",")}"
    }
  end

  def extract_dollar(current_dollar) do
    Float.to_string(current_dollar["ask"], decimals: 2)
  end

  def get_poke() do
    dollar_now = get_dollar

    get_pokedex
    |> Enum.at(dollar_now.poke_id - 1)
    |> improve_poke_response(dollar_now)
  end

  def improve_poke_response(poke, dollar_now) do
    Map.put(dollar_now, :poke, poke["name"]["english"])
  end

  def get_pokedex do
    with {:ok, body} <- File.read("priv/pokedex.json"),
         {:ok, json} <- Poison.decode(body) do
      json
    end
  end
end
