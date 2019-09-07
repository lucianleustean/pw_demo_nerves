defmodule PwDemo.Sensors.SoilMoisture.Impl do
  @moduledoc false

  @channel_0 <<0x01, 0x80, 0x00>>

  def new() do
    {:ok, ref} = Circuits.SPI.open("spidev0.0")
    ref
  end

  def read_soil_moisture(ref) do
    ref
    |> spi_transfer()
    |> spi_read
  end

  defp spi_transfer(ref) do
    ref |> Circuits.SPI.transfer(@channel_0)
  end

  defp spi_read({:ok, <<_::size(14), count::size(10)>>}) do
    level = "#{count / 8.2 |> trunc}%"
    IO.puts("Moisture level: #{level}")
    level
  end
  defp spi_read(_dummy_data) do
    IO.puts("Moisture sensor responded with unexpeced data ..")
  end
end
