extends Node2D

export var data: Resource

onready var _area2d: Area2D = $"%Area2D"
onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _health: float

func damage(amount):
  _health -= amount

func _process(delta):
  if _health <= 0:
    queue_free()

func _ready():
  _health = data.health
