extends Node2D

const PROJECTILE_SCENE: PackedScene = preload("res://actors/Projectile.tscn")

export var animation_offset: Vector2
export var data: Resource

onready var _animation_player: AnimationPlayer = $"%AnimationPlayer"
onready var _orbit_distance_offset: float = rand_range(60.0, 90.0)
onready var _player_node: Node2D = get_tree().get_nodes_in_group("player_node")[0]

var _dead: bool = false
var _time_to_activate: float = 0

func _activate():
  var _new_projectile: Node2D = PROJECTILE_SCENE.instance()

  _new_projectile.global_position = global_position
  _new_projectile.global_rotation = global_rotation

  _new_projectile.data = data.projectile

  get_tree().get_root().add_child(_new_projectile)

func _on_player_died():
  _dead = true
  queue_free()

func _process(delta):
  if !_dead:
    _time_to_activate = clamp(_time_to_activate - delta, 0, data.cooldown)

    if _time_to_activate == 0:
      _activate()
      _time_to_activate = data.cooldown

    global_position = _player_node.global_position + (animation_offset * _orbit_distance_offset)

    if data.follows_rotation:
      look_at(get_global_mouse_position())

func _ready():
  _player_node.connect("died", self, "_on_player_died")

  _animation_player.add_animation("orbit", data.animation)
  _animation_player.play("orbit")
  _animation_player.seek(rand_range(0.0, 2.0), true)

  _time_to_activate = data.cooldown
