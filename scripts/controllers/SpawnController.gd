extends Node

const UNIT_DATA: Array = [
  preload("res://data/units/basic_enemy.tres"),
]
const UNIT_SCENE: PackedScene = preload("res://actors/Unit.tscn")
const UNIT_SPAWN_INTERVAL: float = 2.5
const UNIT_SPAWN_RANGE: float = 500.0

var _player: Node2D
var _spawning: bool = false
var _time_to_spawn: float = UNIT_SPAWN_INTERVAL

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_IN_PROGRESS:
          _player = get_tree().get_nodes_in_group("player_node")[0]
          _spawning = true
        _:
          _spawning = false

func _process(delta):
  if _spawning:
    _time_to_spawn = clamp(_time_to_spawn - delta, 0, UNIT_SPAWN_INTERVAL)

    if _time_to_spawn == 0:
      var _new_unit: Node2D = UNIT_SCENE.instance()

      _new_unit.global_position = (
        _player.global_position
        + (
          Vector2(rand_range(-1.0, 1.0), rand_range(-1.0, 1.0)).normalized()
          * UNIT_SPAWN_RANGE
        )
      )
      _new_unit.data = UNIT_DATA[randi() % UNIT_DATA.size()]
      get_tree().get_root().add_child(_new_unit)

      _time_to_spawn = UNIT_SPAWN_INTERVAL

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
