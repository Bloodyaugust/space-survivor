extends Control

onready var _difficulty_modifier: Label = $"%DifficultyModifier"

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "debug":
      visible = substate

func _process(delta):
  if visible:
    _difficulty_modifier.text = "DMOD: %f" % SpawnController.get_difficulty_modifier()

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  visible = Store.state.debug
