defmodule PwDemoTest do
  use ExUnit.Case
  doctest PwDemo

  test "greets the world" do
    assert PwDemo.hello() == :world
  end
end
