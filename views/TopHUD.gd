extends Control

onready var _kills: Label = $"%Kills"
onready var _level: Label = $"%Level"

func _hide():
  visible = false

  var _tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

  _tween.tween_property(self, "rect_position", Vector2(rect_position.x, -100), 0.25)

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "game":
      match substate:
        GameConstants.GAME_IN_PROGRESS:
          _show()
        _:
          _hide()

    "kills":
      _kills.text = "%d" % substate

    "level":
      _level.text = "%d" % substate

func _ready():
  visible = false

  Store.connect("state_changed", self, "_on_store_state_changed")

func _show():
  visible = true
  _kills.text = "%d" % Store.state.kills
  _level.text = "%d" % Store.state.level
  
  var _tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

  _tween.tween_property(self, "rect_position", Vector2(rect_position.x, 0), 0.25)
