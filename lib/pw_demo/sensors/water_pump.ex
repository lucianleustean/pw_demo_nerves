defmodule PwDemo.Sensors.WaterPump do
  @moduledoc """
  Functions for tunning on and off a relat that controls a water pump
  """
  use GenServer

  def init(args) do
    {:ok, args}
  end

  @doc """
  Start watering for a limited time only
  """
  def water(unit) do
    GenServer.call(:water_pump, {:water, unit})
  end

  @doc """
  Turn on the water pump
  """
  def on() do
    GenServer.call(:water_pump, :on)
  end

  @doc """
  Turn off the water pump
  """
  def off() do
    GenServer.call(:water_pump, :off)
  end
end
