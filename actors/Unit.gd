extends Node2D

const EXPERIENCE_SCENE: PackedScene = preload("res://actors/Experience.tscn")
const HEALTH_MODIFIER_SCALAR: float = 1.5

export var data: Resource

var difficulty_modifier: float = 0.0

onready var _area2d: Area2D = $"%Area2D"
onready var _player: Node2D = get_tree().get_nodes_in_group("player_node")[0]
onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _dead: bool = false
var _health: float

func damage(amount):
  if !_dead:
    _health -= amount

    if _health <= 0:
      _dead = true
      Store.set_state("kills", Store.state.kills + 1)

      call_deferred("_create_experience")

      queue_free()

func _create_experience():
  var _new_experience: Node2D = EXPERIENCE_SCENE.instance()

  _new_experience.global_position = global_position
  _new_experience.set_meta("experience_amount", data.experience)

  get_tree().get_root().add_child(_new_experience)

func _on_area2d_area_entered(area: Area2D):
  var _parent: Node2D = area.get_parent()
  
  if _parent.is_in_group("player_node"):
    _parent.damage(1.0)
    damage(_health)

func _on_player_died():
  _dead = true

func _process(delta):
  if !_dead:
    var _player_direction: Vector2 = global_position.direction_to(_player.global_position)

    global_position += _player_direction * data.speed * delta

func _ready():
  _area2d.connect("area_entered", self, "_on_area2d_area_entered")
  _player.connect("died", self, "_on_player_died")

  _health = data.health + (difficulty_modifier * HEALTH_MODIFIER_SCALAR)
