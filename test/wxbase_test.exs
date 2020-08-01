defmodule WxbaseTest do
  use ExUnit.Case
  doctest Wxbase

  test "greets the world" do
    assert Wxbase.hello() == :world
  end
end
