extends Node2D

const SPEED: float = 250.0

onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _direction: Vector2

func _on_screen_exited():
  queue_free()

func _process(delta):
  global_position += _direction * SPEED * delta

func _ready():
  _visibility_notifier.connect("screen_exited", self, "_on_screen_exited")

  _direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
