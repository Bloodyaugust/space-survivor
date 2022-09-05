extends Control

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "level":
      # TODO: Show this view, then hide on selection of reward
      pass

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")
