extends Node2D

const DAMAGE: float = 1.0
const SPEED: float = 250.0

onready var _area2d: Area2D = $"%Area2D"
onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _direction: Vector2

func _on_area_entered(area: Area2D):
  var _parent: Node2D = area.get_parent()
  
  if _parent.is_in_group("units"):
    _parent.damage(DAMAGE)
    queue_free()

func _on_screen_exited():
  queue_free()

func _process(delta):
  global_position += _direction * SPEED * delta

func _ready():
  _area2d.connect("area_entered", self, "_on_area_entered")
  _visibility_notifier.connect("screen_exited", self, "_on_screen_exited")

  _direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
