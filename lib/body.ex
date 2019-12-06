defmodule UniversalOrbitMap.Body do
  defstruct [:orbit, :name, :all_orbits]

  def new(name) do
    %__MODULE__{name: name, orbit: nil, all_orbits: []}
  end

  def new(name, orbit_name) do
    %__MODULE__{name: name, orbit: orbit_name, all_orbits: []}
  end

  def add_orbits(%__MODULE__{orbit: nil} = body, orbit_name) do
    %{body | orbit: orbit_name}
  end

  def add_total_orbit(%__MODULE__{all_orbits: current_orbits} = body, orbit) do
    %{body | all_orbits: current_orbits ++ [orbit]}
  end
end
