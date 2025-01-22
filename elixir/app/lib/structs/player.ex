defmodule App.Lib.Structs.Player do
  @enforce_keys [
    :nick,
    :space,
    :ships,
    :status
  ]
  defstruct [
    :nick,
    :space,
    :ships,
    :status
  ]

  def new(nickname) do
    new(nickname, :waiting)
  end

  def new(nickname, status) do
    alias App.Lib.Modules.GameIo

    field = GameIo.request_field(nickname)

    %__MODULE__{
      nick: nickname,
      space: field.space,
      ships: field.ships,
      status: status
    }
  end
  
  def switch_status(player) do
    case player.status do
      :active ->
        %__MODULE__{
          nick: player.nick,
          space: player.field,
          ships: player.ships,
          status: :waiting
        }
      :waiting ->
        %__MODULE__{
          nick: player.nick,
          space: player.field,
          ships: player.ships,
          status: :active
        }
    end
  end
end
