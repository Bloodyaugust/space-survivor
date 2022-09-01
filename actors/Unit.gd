extends Node2D

const EXPERIENCE_SCENE: PackedScene = preload("res://actors/Experience.tscn")

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

      call_deferred("_create_experience")

      queue_free()

func _create_experience():
  var _new_experience: Node2D = EXPERIENCE_SCENE.instance()

  _new_experience.global_position = global_position
  _new_experience.set_meta("experience_amount", data.experience)

  get_tree().get_root().add_child(_new_experience)

func _ready():
  _health = data.health
