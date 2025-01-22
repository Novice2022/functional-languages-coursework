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
end
