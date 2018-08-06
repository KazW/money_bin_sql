defmodule MoneyBinDemoTest do
  use ExUnit.Case
  doctest MoneyBinDemo

  test "greets the world" do
    assert MoneyBinDemo.hello() == :world
  end
end
