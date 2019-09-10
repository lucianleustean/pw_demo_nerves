defmodule PwDemo.Mqtt do
  use Tortoise.Handler
  require Logger

  def init(args) do
    {:ok, args}
  end

  # `status` will be either `:up` or `:down`; you can use this to
  # inform the rest of your system if the connection is currently
  # open or closed; tortoise should be busy reconnecting if you get
  # a `:down`
  def connection(status, state) do
    Logger.info "MQTT client connection status: #{status}"
    {:ok, state}
  end

  #  topic filter devices/+/command
  def handle_message(_topic, "/help", state) do
    publish("Commands available: <b>/status</b> and <b>/water</b> <i>unit</i>")
    {:ok, state}
  end
  def handle_message(topic, "/status", state) do
    Logger.info "Command received: /status on topic: #{topic}"
    PwDemo.Sensors.SoilMoisture.read() |> publish()
    {:ok, state}
  end
  def handle_message(topic, "/water" <> unit, state) do
    Logger.info "Command received: /water with #{unit} on topic: #{topic}"

    case unit |> String.trim |> Integer.parse do
      {val, ""} ->
        PwDemo.Sensors.WaterPump.water(val)
        publish("#{val * 30}ml of water added to the plant")
      _error ->
        publish("Sorry,can't process the value, please give me a unit !")
    end

    {:ok, state}
  end
  def handle_message(_topic, _payload, state) do
    "Sorry, can't understand the command, master !" |> publish()
    {:ok, state}
  end

  def subscription(_status, _topic_filter, state) do
    {:ok, state}
  end

  # tortoise doesn't care about what you return from terminate/2,
  # that is in alignment with other behaviours that implement a
  # terminate-callback
  def terminate(_reason, _state) do
    :ok
  end

  def publish(message) do
    Tortoise.publish(:pw_demo_rpi, "devices/rpi", message)
  end
end
