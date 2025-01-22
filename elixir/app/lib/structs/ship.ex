defmodule App.Lib.Structs.Ship do
  @enforce_keys [
    :size,
    :orientation,
    :top_left_coord
  ]
  defstruct [
    :size,
    :orientation,
    :top_left_coord,
    is_alive: true
  ]

  def top_left_ship_coord(size, orientation) do
    coords = %{
      x: trunc(:rand.uniform() * 10),
      y: trunc(:rand.uniform() * 10)
    }

    case orientation do
      :horizontal when coords.x + size - 1 < 10 ->
        %{
          x: coords.x + 1,
          y: coords.y + 1
        }
      :vertical when coords.y + size - 1 < 10 ->
        %{
          x: coords.x + 1,
          y: coords.y + 1
        }
      _ -> top_left_ship_coord(size, orientation)
    end
  end

  def new(size) do
    orientation = Enum.random([:horizontal, :vertical])

    %__MODULE__{
      size: size,
      orientation: orientation,
      top_left_coord: top_left_ship_coord(size, orientation)
    }
  end
end
