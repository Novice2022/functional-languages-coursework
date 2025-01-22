defmodule App do
  alias App.Lib.Structs
  alias App.Lib.Modules.GameIo

  def run do
    GameIo.welcome()
    nicknames = GameIo.get_nicknames()

    session = Structs.Session.new(
      Structs.Player.new(
        nicknames.left,
        :active
      ),
      Structs.Player.new(
        nicknames.right
      )
    )

    Structs.Session.run(session)
  end
end
