defmodule App.Lib.Structs.Player do
  @enforce_keys [
    :nick,
    :real_space,
    :ships,
    :status
  ]
  defstruct [
    :nick,
    :real_space,
    :visible_space,
    :ships,
    :status,
    hp_remains: 20
  ]

  def new(nickname) do
    new(nickname, :waiting)
  end

  def new(nickname, status) do
    alias App.Lib.Modules.GameIo

    field = GameIo.request_field(nickname)

    %__MODULE__{
      nick: nickname,
      real_space: field.space,
      visible_space: Tuple.duplicate(
        Tuple.duplicate(" ", 12),
        12
      ),
      ships: field.ships,
      status: status
    }
  end
  
  def update_status(player, new_status) do
    %__MODULE__{
      nick: player.nick,
      real_space: player.real_space,
      visible_space: player.visible_space,
      ships: player.ships,
      status: new_status,
      hp_remains: player.hp_remains
    }
  end

  def update(
    player,
    new_visible_space,
    status
  ) do
    %__MODULE__{
      nick: player.nick,
      real_space: player.real_space,
      visible_space: new_visible_space,
      ships: player.ships,
      status: status,
      hp_remains: player.hp_remains
    }
  end

  def get_damage(player) do
    new_hp = player.hp_remains - 1

    %__MODULE__{
      nick: player.nick,
      real_space: player.real_space,
      visible_space: player.visible_space,
      ships: player.ships,
      status: player.status,
      hp_remains: new_hp
    }
  end

  def search_ship(ships, row, column) do
    if row == nil do
      nil
    else
      ships
        |> Enum.find(
          fn ship ->
            ship.top_left_coord == %{
              x: column,
              y: row
            }
          end
        )
    end
  end
end
