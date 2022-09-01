extends Node2D

export var data: Resource

onready var _area2d: Area2D = $"%Area2D"
onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _dead: bool = false
var _health: float

func damage(amount):
  if !_dead:
    _health -= amount

    if _health <= 0:
      _dead = true
      Store.set_state("kills", Store.state.kills + 1)
      queue_free()

func _ready():
  _health = data.health
