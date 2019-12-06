defmodule UniversalOrbitMap.Space do
  defstruct [:bodies, :total_orbits]

  alias UniversalOrbitMap.Body

  def new() do
    %__MODULE__{bodies: %{}, total_orbits: 0}
  end

  def add_orbit(%__MODULE__{bodies: bodies} = space, name, orbit_name) do
    bodies = get_or_create(bodies, orbit_name)
    %{space | bodies: get_or_create(bodies, name, orbit_name)}
  end

  def count_orbits(%__MODULE__{bodies: bodies} = space) do
    Map.keys(bodies)
    |> Enum.reduce(space, &count_orbits/2)
    |> total_orbits()
  end

  def transfers_between(%__MODULE__{bodies: bodies}, start_name, end_name) do
    start_orbits = Map.get(bodies, start_name).all_orbits
    end_orbits = Map.get(bodies, end_name).all_orbits
    first_match = first_match(start_orbits, end_orbits)
    count_to(start_orbits, first_match) + count_to(end_orbits, first_match)
  end

  defp count_to(orbits, match) do
    Enum.reduce_while(orbits, 0, fn orbit, count ->
      case orbit == match do
        true -> {:halt, count}
        _ -> {:cont, count + 1}
      end
    end)
  end

  defp first_match(start_orbits, end_orbits) do
    Enum.find(start_orbits, fn o -> Enum.find(end_orbits, &(&1 == o)) end)
  end

  defp total_orbits(%__MODULE__{bodies: bodies} = space) do
    Map.keys(bodies)
    |> Enum.reduce(space, &count_total_orbits/2)
  end

  defp count_total_orbits(name, %__MODULE__{bodies: bodies, total_orbits: count} = space) do
    %{space | total_orbits: Enum.count(Map.get(bodies, name).all_orbits) + count}
  end

  defp count_orbits(name, %__MODULE__{bodies: bodies} = space) do
    original_body = Map.get(bodies, name)
    count(space, original_body, original_body)
  end

  defp count(space, original_body, %Body{orbit: nil}) do
    replace(space, original_body.name, original_body)
  end

  defp count(%__MODULE__{bodies: bodies} = space, original_body, %Body{orbit: orbit}) do
    count(space, Body.add_total_orbit(original_body, orbit), Map.get(bodies, orbit))
  end

  defp replace(%__MODULE__{bodies: bodies} = space, name, new_body) do
    %{space | bodies: Map.replace!(bodies, name, new_body)}
  end

  defp get_or_create(bodies, name) do
    case Map.get(bodies, name) do
      nil ->
        new_body = Body.new(name)
        Map.put(bodies, name, new_body)

      _ ->
        bodies
    end
  end

  defp get_or_create(objects, name, orbit_name) do
    case Map.get(objects, name) do
      nil ->
        new_object = Body.new(name, orbit_name)
        Map.put(objects, name, new_object)

      val ->
        update_object = Body.add_orbits(val, orbit_name)
        Map.put(objects, name, update_object)
    end
  end
end
