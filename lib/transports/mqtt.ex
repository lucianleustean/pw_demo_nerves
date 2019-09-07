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
  def handle_message(topic, payload, state) do
    "Sorry, I can't understand your command" |> publish()
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
