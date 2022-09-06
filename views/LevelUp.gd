extends Control

const REWARD_SCENE: PackedScene = preload("res://views/components/Reward.tscn")

onready var _rewards_container: Control = $"%Rewards"

var _rewards: Array = []

func _get_allowed_rewards() -> Array:
  var _allowed_rewards: Array = []

  for _reward in _rewards:
    if _reward.repeatable:
      _allowed_rewards.append(_reward)
      continue
    
    if !_reward in Store.state.rewards:
      if _reward.level == 0:
        _allowed_rewards.append(_reward)
        continue
        
      var _reward_key: String = _reward.key
      var _rewards_with_key: Array = []
      
      for _reward_to_check in Store.state.rewards:
        if _reward_to_check.key == _reward_key:
          _rewards_with_key.append(_reward_to_check)
          
      if _reward.level == _rewards_with_key.size():
        _allowed_rewards.append(_reward)

  return _allowed_rewards

func _hide():
  var _tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

  _tween.tween_property(self, "rect_position", Vector2(rect_position.x, -1000), 0.25)

  _tween.connect("finished", self, "set", ["visible", false])

func _on_store_state_changed(state_key: String, substate):
  match state_key:
    "level":
      var _allowed_rewards: Array = _get_allowed_rewards()

      _show()
      get_tree().paused = true
      GDUtil.queue_free_children(_rewards_container)

      for _reward in _allowed_rewards:
        var _new_reward_component: Control = REWARD_SCENE.instance()

        _new_reward_component.data = _reward
        _rewards_container.add_child(_new_reward_component)

    "rewards":
      get_tree().paused = false
      _hide()

func _ready():
  Store.connect("state_changed", self, "_on_store_state_changed")

  var _reward_resource_files: Array = GDUtil.get_files_in_directory("res://data/rewards/")

  for _file in _reward_resource_files:
    _rewards.append(load("res://data/rewards/%s" % _file))

  _hide()

func _show():
  visible = true

  var _tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)

  _tween.tween_property(self, "rect_position", Vector2(rect_position.x, 0), 0.25)
