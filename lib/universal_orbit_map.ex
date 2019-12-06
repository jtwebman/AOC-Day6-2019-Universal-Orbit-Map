defmodule UniversalOrbitMap do
  alias UniversalOrbitMap.{Space, Input}

  def run() do
    run(Input.input())
  end

  def run_test() do
    run(Input.test_santa())
  end

  def run(input) do
    input
    |> parse_input()
    |> add_to_space()
    |> Space.count_orbits()
    |> Space.transfers_between("YOU", "SAN")
  end

  def run_part1() do
    run_part1(Input.input())
  end

  def run_test_part1() do
    run_part1(Input.test_input())
  end

  def run_part1(input) do
    input
    |> parse_input()
    |> add_to_space()
    |> Space.count_orbits()
  end

  defp add_to_space(inputs) do
    Enum.reduce(inputs, Space.new(), &add_orbits/2)
  end

  defp add_orbits([orbit_name, name], space) do
    Space.add_orbit(space, name, orbit_name)
  end

  defp add_orbits([""], space) do
    space
  end

  defp parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&split_orbits/1)
  end

  defp split_orbits(line) do
    line
    |> String.split(")")
  end
end
