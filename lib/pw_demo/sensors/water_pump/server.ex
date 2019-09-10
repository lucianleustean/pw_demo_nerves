defmodule PwDemo.Sensors.WaterPump.Server do
  @moduledoc false
  use GenServer
  alias PwDemo.Sensors.WaterPump.Impl
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :water_pump)
  end

  def init(_) do
    {:ok, %{relay: Impl.new()}}
  end

  def handle_info(:stop_pump, state) do
    Impl.pump_off(state[:relay])

    {:noreply, state}
  end

  def handle_call({:water, unit}, _from, state) do
    Impl.pump_on(state[:relay])

    Process.send_after(self(), :stop_pump, unit * 1_000)

    {:reply, :ok, state}
  end
  def handle_call(:on, _from, state) do
    {:reply, Impl.pump_on(state[:relay]), state}
  end
  def handle_call(:off, _from, state) do
    {:reply, Impl.pump_off(state[:relay]), state}
  end
end
