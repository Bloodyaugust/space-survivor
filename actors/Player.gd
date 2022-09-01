extends Node2D

signal died

const EXPERIENCE_PER_LEVEL: float = 100.0
const HEALTH: float = 10.0
const MOVE_SPEED: float = 50.0

onready var _experience_collector: Area2D = $"%ExperienceCollector"
onready var _hitbox: Area2D = $"%Hitbox"

var _experience: float = 0.0
var _health: float = HEALTH
var _level: int = 1

func damage(amount: float):
  _health -= amount

  if _health <= 0:
    queue_free()
    Store.set_state("game", GameConstants.GAME_OVER)
    Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)
    emit_signal("died")

func _on_experience_collected(experience: Node2D):
  _experience += experience.get_meta("experience_amount", 0)

  if _experience >= EXPERIENCE_PER_LEVEL:
    _experience -= EXPERIENCE_PER_LEVEL
    _level += 1
    Store.set_state("level", _level)

  experience.queue_free()

func _on_experience_collector_area_entered(area: Area2D):
  var _parent: Node2D = area.get_parent()

  if _parent.is_in_group("experience"):
    var _tween: SceneTreeTween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
    
    _tween.tween_property(_parent, "global_position", global_position, 0.75)
    _tween.connect("finished", self, "_on_experience_collected", [_parent])

func _process(delta):
  var _movement: Vector2 = Vector2.ZERO

  _movement += Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized() * MOVE_SPEED * delta

  global_position += _movement
  look_at(get_global_mouse_position())

func _ready():
  _experience_collector.connect("area_entered", self, "_on_experience_collector_area_entered")
