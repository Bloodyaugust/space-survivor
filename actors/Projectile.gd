extends Node2D

var data: ProjectileData

onready var _area2d: Area2D = $"%Area2D"
onready var _visibility_notifier: VisibilityNotifier2D = $"%VisibilityNotifier2D"

var _direction: Vector2
var _traveled: float = 0

func _activate(target):
  if target:
    target.damage(data.damage)
    
  if data.aoe > 0:
    var _units: Array = get_tree().get_nodes_in_group("units")
    var _affected_units: Array = []
    
    for _unit in _units:
      if global_position.distance_to(_unit.global_position) <= data.aoe && (!target || _unit != target):
        _affected_units.append(_unit)
        
    for _unit in _affected_units:
      # TODO: Scale with distance
      _unit.damage(data.damage)

  queue_free()

func _on_area_entered(area: Area2D):
  var _parent: Node2D = area.get_parent()

  if _parent.is_in_group("units"):
    _activate(_parent)

func _on_screen_exited():
  queue_free()

func _process(delta):
  var _distance_this_frame:float = data.speed * delta

  if "seeking" in data.attributes:
    # TODO: Get whole list and sort by distance
    var _units = get_tree().get_nodes_in_group("units")
    var _target_unit = null if _units.size() == 0 else _units[0]

    if _target_unit:
      _direction = (_target_unit.global_position - global_position).normalized()

  global_position += _direction * _distance_this_frame
  _traveled += _distance_this_frame

  if _traveled >= data.max_range && data.max_range != 0.0:
    _activate(null)

func _ready():
  _area2d.connect("area_entered", self, "_on_area_entered")
  _visibility_notifier.connect("screen_exited", self, "_on_screen_exited")

  _direction = Vector2(cos(global_rotation), sin(global_rotation)).normalized()
