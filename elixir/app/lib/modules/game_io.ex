defmodule App.Lib.Modules.GameIo do
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
        IO.puts("10 ║ #{Enum.join(space_row, " ")}")
      end
    end
  end
end
