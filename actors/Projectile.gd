extends Node2D

const SPEED: float = 250.0

var _direction: Vector2

func _process(delta):
  global_position += _direction * SPEED * delta

func _ready():
  _direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
