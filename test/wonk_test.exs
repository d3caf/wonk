defmodule WonkTest do
  use ExUnit.Case
  doctest Wonk

  test "greets the world" do
    assert Wonk.hello() == :world
  end
end
