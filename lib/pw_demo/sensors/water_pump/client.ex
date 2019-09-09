defmodule PwDemo.Sensors.WaterPump.Impl do
  @moduledoc false
  require Logger

  @water_pump 21

  def new() do
    {:ok, gpio} = Circuits.GPIO.open(@water_pump, :output)
    pump_off(gpio)
    gpio
  end

  def pump_on(gpio) do
    Circuits.GPIO.write(gpio, 0)
  end

  def pump_off(gpio) do
    Circuits.GPIO.write(gpio, 1)
  end
end
