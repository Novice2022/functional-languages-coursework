defmodule App do
  alias App.Lib.Structs.Field
  alias App.Lib.Modules.GameIo

  def run do
    field = Field.new()

    IO.puts("Field created")
    GameIo.print_space(field.space)
  end
end
