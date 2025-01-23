defmodule App.Lib.Structs.Field do
  alias App.Lib.Structs.Ship

  @enforce_keys [
    :space,
    :ships
  ]
  defstruct [
    :space,
    :ships
  ]

  def has_obstacles(space, ship) do
    if ship.orientation == :horizontal do
      ship_area = for row <- (ship.top_left_coord.y - 1)..(ship.top_left_coord.y + 1) do
        for column <- (ship.top_left_coord.x - 1)..(ship.top_left_coord.x + ship.size) do
          elem(elem(space, row), column)
        end
      end

      has_obstacles = Enum.any?(
        ship_area,
        fn row -> Enum.any?(row, fn point -> point == "#" end) end
      )

      has_obstacles
    else
      ship_area = for column <- (ship.top_left_coord.x - 1)..(ship.top_left_coord.x + 1) do
        for row <- (ship.top_left_coord.y - 1)..(ship.top_left_coord.y + ship.size) do
          elem(elem(space, row), column)
        end
      end

      has_obstacles = Enum.any?(
        ship_area,
        fn row -> Enum.any?(row, fn point -> point == "#" end) end
      )

      has_obstacles
    end
  end
  
  def create_ship_at_free_space(space, ship_size) do
    ship = Ship.new(ship_size)

    if has_obstacles(space, ship) do
      create_ship_at_free_space(space, ship_size)
    else
      ship
    end
  end

  def arrange_ship(space, ships, ship) do
    if ship.orientation == :horizontal do
      space_row = elem(space, ship.top_left_coord.y)

      { new_space, _ } = Enum.reduce(
        0..ship.size - 1,
        { space, space_row },
        fn ship_point, { space, space_row } ->
          space_row = put_elem(
            space_row,
            ship.top_left_coord.x + ship_point,
            "#"
          )

          {
            put_elem(
              space,
              ship.top_left_coord.y,
              space_row    
            ),
            space_row
          }
        end
      )

      { new_space, ships ++ [ship] }
    else
      new_space = Enum.reduce(
        ship.top_left_coord.y..(ship.top_left_coord.y + ship.size - 1),
        space,
        fn row, space ->
          space_row = elem(space, row)

          put_elem(
            space,
            row,
            put_elem(
              space_row,
              ship.top_left_coord.x,
              "#"
            )
          )            
        end
      )

      { new_space, ships ++ [ship] }
    end
  end

  def new do
    space = Tuple.duplicate(Tuple.duplicate(" ", 12), 12)
    ships = []

    { space, ships } = Enum.reduce(
      1..4,
      { space, ships },
      fn ship_size, { space, ships } ->
        Enum.reduce(
          1..(5 - ship_size),
          { space, ships },
          fn _, { space, ships } ->
            arrange_ship(
              space,
              ships,
              create_ship_at_free_space(
                space,
                ship_size
              )
            )
          end)
    end)

    %__MODULE__{space: space, ships: ships}
  end

  def print_space(space) do
    IO.puts("   ║ а б в г д е ж з и к")
    IO.puts("═══╬════════════════════")
    for row <- 1..10 do
      space_row = for column <- 1..10 do
        elem(elem(space, row), column)
      end

      if row < 10 do
        IO.puts("#{row}  ║ #{Enum.join(space_row, " ")}")
      else
        IO.puts("10 ║ #{Enum.join(space_row, " ")}\n")
      end
    end
  end
end
