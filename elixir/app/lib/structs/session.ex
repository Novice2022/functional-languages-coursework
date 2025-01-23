defmodule App.Lib.Structs.Session do
  alias App.Lib.Modules.GameIo

  @enforce_keys [
    :left_player,
    :right_player
  ]
  defstruct [
    :left_player,
    :right_player
  ]

  def new(left_player, right_player) do
    %__MODULE__{
      left_player: left_player,
      right_player: right_player
    }
  end

  def cut_overflowed_nickname(nickname) do
    if String.length(nickname) > 10 do
      String.slice(nickname, 0, 10) <> "…"
    else
      nickname
    end
  end

  def print_row(row_index, left_field, right_field) do
    left_row = Enum.join(
      (for column <- 1..10, do: elem(elem(left_field, row_index), column)),
      " "
    )
    right_row = Enum.join(
      (for column <- 1..10, do: elem(elem(right_field, row_index), column)),
      " "
    )

    if row_index < 10 do
      IO.puts("#{row_index}  ║ #{left_row}          #{row_index}  ║ #{right_row}")
    else
      IO.puts("#{row_index} ║ #{left_row}          #{row_index} ║ #{right_row}")
    end
  end

  def print(session) do
    GameIo.clear_console()

    left_nickname = cut_overflowed_nickname(session.left_player.nick)
    right_nickname = cut_overflowed_nickname(session.right_player.nick)

    space_between_nicknames = String.duplicate(
      " ",
      58 - String.length(left_nickname) - String.length(right_nickname)
    )

    IO.puts(String.trim_trailing(~s"""
      % - попадание
      ~ - промах

      #{left_nickname}#{space_between_nicknames}#{right_nickname}
      
         ║ а б в г д е ж з и к             ║ а б в г д е ж з и к
      ═══╬════════════════════          ═══╬════════════════════
      """, "\n")
    )

    for row_index <- 1..3, do:
      print_row(
        row_index,
        session.left_player.visible_space,
        session.right_player.visible_space
      )
    
    case session.left_player.status do
      :active ->
        IO.puts(
          String.trim_trailing(~s"""
            4  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 4), column)), " ")}    \\     #{4}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 4), column)), " ")}
            5  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 5), column)), " ")}     \\    #{5}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 5), column)), " ")}
            6  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 6), column)), " ")}     /    #{6}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 6), column)), " ")}
            7  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 7), column)), " ")}    /     #{7}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 7), column)), " ")}
            """
          )
        )
      :waiting ->
        IO.puts(
          String.trim_trailing(~s"""
            4  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 4), column)), " ")}     /    #{4}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 4), column)), " ")}
            5  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 5), column)), " ")}    /     #{5}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 5), column)), " ")}
            6  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 6), column)), " ")}    \\     #{6}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 6), column)), " ")}
            7  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.left_player.visible_space, 7), column)), " ")}     \\    #{7}  ║ #{Enum.join((for column <- 1..10, do: elem(elem(session.right_player.visible_space, 7), column)), " ")}
            """,
            "\n"
          )
        )
    end

    for row_index <- 8..10, do:
      print_row(
        row_index,
        session.left_player.visible_space,
        session.right_player.visible_space
      )
  end

  def get_shot_result(real_space, row, column) do
    case get_space_point(
      real_space,
      row,
      column
    ) do
      " " ->
        "~"
      "#" ->
        "%"
    end
  end

  def get_space_point(space, row, column) do
    space
      |> elem(row)
      |> elem(column)
  end

  def update_tuple(tuple, row, column, new_item) do
    put_elem(
      tuple,
      row,
      put_elem(
        elem(tuple, row),
        column,
        new_item
      )
    )
  end

  def move_left_while_ship(space, row, column) do
    if get_space_point(space, row, column - 1) in ["#", "%"] do
      move_left_while_ship(space, row, column - 1)
    else
      { column, row }
    end
  end

  def move_heigher_while_ship(space, row, column) do
    if get_space_point(space, row - 1, column) in ["#", "%"] do
      move_heigher_while_ship(space, row - 1, column)
    else
      { column, row }
    end
  end

  def paint_over_the_area(space, row, column, orientation, length) do
    case orientation do
      :horizontal ->
        new_space = space
          |> update_tuple(row - 1, column - 1, "~")
          |> update_tuple(row, column - 1, "~")
          |> update_tuple(row + 1, column - 1, "~")

        new_space = Enum.reduce(
          0..length - 1,
          new_space,
          fn iteration_point_x, new_space ->
            new_space
              |> update_tuple(row - 1, column + iteration_point_x, "~")
              |> update_tuple(row, column + iteration_point_x, "%")
              |> update_tuple(row + 1, column + iteration_point_x, "~")
          end
        )

        new_space
          |> update_tuple(row - 1, column + length, "~")
          |> update_tuple(row, column + length, "~")
          |> update_tuple(row + 1, column + length, "~")
      :vertical ->
        new_space = space
          |> update_tuple(row - 1, column - 1, "~")
          |> update_tuple(row - 1, column, "~")
          |> update_tuple(row - 1, column + 1, "~")

        new_space = Enum.reduce(
          0..length - 1,
          new_space,
          fn iteration_point_y, new_space ->
            new_space
              |> update_tuple(row + iteration_point_y, column - 1, "~")
              |> update_tuple(row + iteration_point_y, column, "%")
              |> update_tuple(row + iteration_point_y, column + 1, "~")
          end
        )

        new_space
          |> update_tuple(row + length, column - 1, "~")
          |> update_tuple(row + length, column, "~")
          |> update_tuple(row + length, column + 1, "~")
    end
  end

  def ship_alive(space_real, space_visible, ship) do
    if ship == nil do
      true
    else
      case ship.orientation do
        :horizontal ->
          Enum.any?(
            0..ship.size - 1,
            fn x_point ->
              get_space_point(
                space_real,
                ship.top_left_coord.y,
                ship.top_left_coord.x + x_point
              ) == "#" and
              get_space_point(
                space_visible,
                ship.top_left_coord.y,
                ship.top_left_coord.x + x_point
              ) == " "
            end
          )
        :vertical ->
          Enum.any?(
            0..ship.size,
            fn y_point ->
              get_space_point(
                space_real,
                ship.top_left_coord.y + y_point,
                ship.top_left_coord.x
              ) == "#" and
              get_space_point(
                space_visible,
                ship.top_left_coord.y + y_point,
                ship.top_left_coord.x
              ) == " "
            end
          )
      end
    end
  end

  def update_space(space_visible, space_real, row, column, new_item, ships) do
    alias App.Lib.Structs.Player

    { left, top } =
      if new_item == "%" do
        { left, top } = move_left_while_ship(
          space_real,
          row,
          column
        )

        move_heigher_while_ship(
          space_real,
          top,
          left
        )
      else
        { nil, nil }
      end

    ship = Player.search_ship(ships, top, left)

    new_visible_space = update_tuple(
      space_visible, row, column, new_item
    )

    ship_is_alive = ship_alive(space_real, new_visible_space, ship)

    new_space = 
      if ship_is_alive do
        update_tuple(
          new_visible_space, row, column, new_item
        )
      else
        paint_over_the_area(
          new_visible_space,
          ship.top_left_coord.y,
          ship.top_left_coord.x,
          ship.orientation,
          ship.size
        )
      end

    if new_item == "%" do
      { new_space, true }
    else
      { new_space, false }
    end
  end

  def take_a_move(session) do
    { row, column } = GameIo.request_shot_coordinates()

    {side, attacked_space_real, attacked_space_visible, ships} =
      with left_player <- session.left_player,
          right_player <- session.right_player do
        if left_player.status == :active do
          {
            :right,
            right_player.real_space,
            right_player.visible_space,
            right_player.ships
          }
        else
          {
            :left,
            left_player.real_space,
            left_player.visible_space,
            left_player.ships
          }
        end
      end

    case get_space_point(attacked_space_visible, row, column) do
      " " ->
        alias App.Lib.Structs.Player

        { new_visible_space, damaged } = update_space(
          attacked_space_visible,
          attacked_space_real,
          row,
          column,
          get_shot_result(attacked_space_real, row, column),
          ships
        )

        if side == :left do
          new_left_player = Player.update(
            session.left_player,
            new_visible_space,
            session.left_player.status
          )

          new_left_player =
            if damaged do
              Player.get_damage(
                new_left_player
              )
            else
              Player.update_status(
                new_left_player,
                :active
              )
            end
          
          new_right_player =
            if damaged do
              session.right_player
            else
              Player.update_status(
                session.right_player,
                :waiting
              )
            end

          %__MODULE__{
            left_player: new_left_player,
            right_player: new_right_player
          }
        else
          new_right_player = Player.update(
            session.right_player,
            new_visible_space,
            session.right_player.status
          )

          new_right_player =
            if damaged do
              Player.get_damage(
                new_right_player
              )
            else
              Player.update_status(
                new_right_player,
                :active
              )
            end

          new_left_player =
            if damaged do
              session.left_player
            else
              Player.update_status(
                session.left_player,
                :waiting
              )
            end
          
          %__MODULE__{
            left_player: new_left_player,
            right_player: new_right_player,
          }
        end
      _ ->
        IO.puts(" Подсказка: стреляйте по не изведанным координатам!")
        take_a_move(session)
    end
  end

  def run(session) do
    print(session)
    new_session = take_a_move(session)

    cond do
      new_session.left_player.hp_remains == 0 ->
        GameIo.announce_the_winner(
          new_session.right_player.nick
        )
        :exit
      new_session.right_player.hp_remains == 0 ->
        GameIo.announce_the_winner(
          new_session.left_player.nick
        )
        :exit
      true ->
        run(new_session)
    end
  end
end
