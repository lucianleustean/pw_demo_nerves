defmodule PwDemo.Sensors.SoilMoisture.Server do
  @moduledoc false
  use GenServer
  alias PwDemo.Sensors.SoilMoisture.Impl

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :soil_moisture_sensor)
  end

  def init(_) do
    {:ok, %{moisture: Impl.new()}}
  end

  def handle_call(:read, _from, state) do
    {:reply, Impl.read_soil_moisture(state[:moisture]), state}
  end
end
