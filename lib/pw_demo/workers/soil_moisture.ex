defmodule PwDemo.Workers.SoilMoisture do
  @moduledoc false
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: :soil_moisture_worker)
  end

  def init(_) do
    schedule_initial_job()

    {:ok, nil}
  end

  def handle_info(:perform, state) do
    PwDemo.Sensors.SoilMoisture.read()

    schedule_next_job()

    {:noreply, state}
  end

  defp schedule_initial_job() do
    # wait 10 seconds to allow networking to connect
    Process.send_after(self(), :perform, 10_000)
  end

  defp schedule_next_job() do
    Process.send_after(self(), :perform, 2_000)
  end
end
