defmodule App.Lib.Modules.GameIo do
  def clear_console do
    System.shell("clear", into: IO.stream())
  end

  def welcome do
    clear_console()
    IO.puts("Добро пожаловать в игру Морской Бой!\n")
  end

  def get_nicknames do
    users = String.trim(
      IO.gets(
        "Введите никнеймы через \", \" для первого и второго игрока соответственно:\n > "
      )
    )

    if (
      String.contains?(users, ", ") and
      !String.starts_with?(users, ", ") and
      !String.ends_with?(users, ", \n")
     ) do
      splited = String.split(users, ", ")

      %{
        left: hd(splited),
        right: hd(tl(splited))
      }
    else
      clear_console()
      get_nicknames()
    end
  end

  def request_field(nickname) do
    alias App.Lib.Structs.Field

    clear_console()

    IO.puts(
      """
      Создание поля игрока [#{nickname}]
        * \".\" - новое поле
        * остальное - сохранить
      
      """
    )
    
    field = Field.new()
    
    Field.print_space(field.space)
    IO.puts("")

    input = IO.gets(" > ")

    if input == ".\n" do
      request_field(nickname)
    else
      field
    end
  end

  def request_shot_coordinates do
    input = String.trim_trailing(
      IO.gets(
        "\nВыберите координаты для выстрела (номер строки и столбца через пробел):\n > "
      ),
      "\n"
    )

    if Regex.match?(~r/^(1[0]|[1-9])\s[а-к]+$/, input) do
      {
        String.to_integer(hd(String.split(input))),
        (String.split(input)
          |> List.last()
          |> String.to_charlist()
          |> List.first()) - 1071
      }
    else
      request_shot_coordinates()
    end
  end

  def announce_the_winner(nickname) do
    IO.puts("\nУра! Победил игрок \"[#{nickname}\"!")
  end
end
