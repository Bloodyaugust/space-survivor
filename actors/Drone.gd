extends Node2D

const PROJECTILE_SCENE: PackedScene = preload("res://actors/Projectile.tscn")

export var data: Resource

onready var _player_node: Node2D = get_tree().get_nodes_in_group("player_node")[0]

var _animation_offset: Vector2
var _time_to_activate: float = 0

func _activate():
  var _new_projectile: Node2D = PROJECTILE_SCENE.instance()
  
  _new_projectile.global_position = global_position
  _new_projectile.global_rotation = global_rotation
  
  get_tree().get_root().add_child(_new_projectile)

func _process(delta):
  _time_to_activate = clamp(_time_to_activate - delta, 0, data.cooldown)
  
  if _time_to_activate == 0:
    _activate()
    _time_to_activate = data.cooldown
    
  global_position = _player_node.global_position + _animation_offset

func _ready():
  _time_to_activate = data.cooldown
