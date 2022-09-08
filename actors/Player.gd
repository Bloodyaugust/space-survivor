extends Node2D

signal died

const HEALTH: float = 10.0
const MAX_LEVEL: int = 100
const MOVE_SPEED: float = 50.0

export var experience_per_level: Curve

onready var _experience_collector: Area2D = $"%ExperienceCollector"
onready var _health_bar: ProgressBar = $"%HealthBar"
onready var _hitbox: Area2D = $"%Hitbox"

var _experience: float = 0.0
var _health: float = HEALTH
var _level: int = 1

func damage(amount: float):
  _health -= amount
  _health_bar.value = _health

  if _health <= 0:
    queue_free()
    Store.set_state("game", GameConstants.GAME_OVER)
    Store.set_state("client_view", ClientConstants.CLIENT_VIEW_MAIN_MENU)
    emit_signal("died")

func heal(amount: float):
  _health = clamp(_health + amount, 0, HEALTH)
  _health_bar.value = _health

func _on_experience_collected(experience: Node2D):
  if experience:
    var _experience_to_next_level: float = experience_per_level.interpolate(float(_level) / float(MAX_LEVEL))
    _experience += experience.get_meta("experience_amount", 0)

    if _experience >= _experience_to_next_level:
      _experience -= _experience_to_next_level
      _level += 1
      Store.set_state("level", _level)

    Store.set_state("level_progress", (_experience / experience_per_level.interpolate(float(_level) / float(MAX_LEVEL))) * 100)
    experience.queue_free()

func _on_experience_collector_area_entered(area: Area2D):
  var _parent: Node2D = area.get_parent()

  if _parent.is_in_group("experience"):
    var _tween: SceneTreeTween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
    
    _tween.tween_property(_parent, "global_position", global_position, 0.75)
    _tween.connect("finished", self, "_on_experience_collected", [_parent])

func _on_reward_chosen(reward: RewardData):
  RewardController.process_reward(self, get_tree().get_root().find_node("Drones", true, false), reward)

func _process(delta):
  var _movement: Vector2 = Vector2.ZERO

  _movement += Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized() * MOVE_SPEED * delta

  global_position += _movement
  look_at(get_global_mouse_position())

func _ready():
  _experience_collector.connect("area_entered", self, "_on_experience_collector_area_entered")
  Store.connect("reward_chosen", self, "_on_reward_chosen")
