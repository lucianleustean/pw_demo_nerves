defmodule PwDemo.Sensors.SoilMoisture do
  @moduledoc """
  Functions for reading the moisture sensor from w/analog voltage output
  connected to an MCP3008 analog to digital conversion chip over SPI.
  """

  use GenServer

  def init(args) do
    {:ok, args}
  end

  @doc """
  Read the current moisture in the soil
  """
  def read() do
    GenServer.call(:soil_moisture_sensor, :read)
  end
end
