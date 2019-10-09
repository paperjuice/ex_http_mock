defmodule ExHttpMockTest do
  use ExUnit.Case
  doctest ExHttpMock

  test "greets the world" do
    assert ExHttpMock.hello() == :world
  end
end
