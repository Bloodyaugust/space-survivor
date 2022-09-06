extends Control

var data: RewardData

onready var _description: Label = $"%Description"
onready var _highlight: ColorRect = $"%Highlight"
onready var _icon: TextureRect = $"%Icon"
onready var _name: Label = $"%Name"
onready var _progression: Label = $"%Progression"

func _on_gui_input(event: InputEvent):
  if event.is_action_released("ui_select"):
    var _new_rewards = Store.state.rewards.duplicate()

    _new_rewards.append(data)
    Store.set_state("rewards", _new_rewards)
    Store.emit_signal("reward_chosen", data)

func _on_mouse_enter():
  _highlight.visible = true

func _on_mouse_exit():
  _highlight.visible = false

func _ready():
  connect("gui_input", self, "_on_gui_input")
  connect("mouse_entered", self, "_on_mouse_enter")
  connect("mouse_exited", self, "_on_mouse_exit")

  _description.text = data.description
  _name.text = data.name
  _progression.text = "New!" if data.level == 0 else "Level %d -> " % data.level + "%d" % (data.level + 1)

  if data.type == "consumable":
    _progression.visible = false

  _highlight.visible = false
