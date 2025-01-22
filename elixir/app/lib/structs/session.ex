defmodule App.Lib.Structs.Session do
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
    if String.length(nickname) > 20 do
      String.slice(nickname, 0, 20) <> "…"
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
    alias App.Lib.Modules.GameIo

    GameIo.clear_console()

    left_nickname = cut_overflowed_nickname(session.left_player.nick)
    right_nickname = cut_overflowed_nickname(session.right_player.nick)

    space_between_nicknames = String.duplicate(
      " ",
      54 - String.length(left_nickname) - String.length(right_nickname)
    )

    IO.puts(String.trim_trailing(~s"""
      [#{left_nickname}]#{space_between_nicknames}[#{right_nickname}]
      
         ║ а б в г д е ж з и к             ║ а б в г д е ж з и к
      ═══╬════════════════════          ═══╬════════════════════
      """, "\n")
    )

    for row_index <- 1..3, do:
      print_row(
        row_index,
        session.left_player.space,
        session.right_player.space
      )
    
    case session.left_player.status do
      :active ->
        IO.puts(String.trim_trailing~s"""
          4  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 4)), " "), 2, 19)}    \\     #{4}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 4)), " "), 2, 19)}
          5  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 5)), " "), 2, 19)}     \\    #{5}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 5)), " "), 2, 19)}
          6  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 6)), " "), 2, 19)}     /    #{6}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 6)), " "), 2, 19)}
          7  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 7)), " "), 2, 19)}    /     #{7}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 7)), " "), 2, 19)}
          """
        )
      :waiting ->
        IO.puts(~s"""
          4  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 4)), " "), 2, 19)}     /     #{4}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 4)), " "), 1, 10)}
          5  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 5)), " "), 2, 19)}    /      #{5}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 5)), " "), 1, 10)}
          6  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 6)), " "), 2, 19)}    \\      #{6}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 6)), " "), 1, 10)}
          7  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.left_player.space, 7)), " "), 2, 19)}     \\     #{7}  ║ #{String.slice(Enum.join(Tuple.to_list(elem(session.right_player.space, 7)), " "), 2, 19)}
          """
        )
    end

    for row_index <- 8..10, do:
      print_row(
        row_index,
        session.left_player.space,
        session.right_player.space
      )
  end

  def run(session) do
    print(session)
    :exit
  end
end
