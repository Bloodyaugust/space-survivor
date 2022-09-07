extends Node

const DRONE_SCENE: PackedScene = preload("res://actors/Drone.tscn")

static func process_reward(player: Node2D, drones_container: Node2D, reward: RewardData) -> void:
  match reward.type:
    "drone":
      if reward.drone:
        var _drone_data: Drone = reward.drone
        var _new_drone: Node2D = DRONE_SCENE.instance()

        _new_drone.global_position = player.global_position
        _new_drone.data = _drone_data

        print(drones_container, _new_drone)
        drones_container.add_child(_new_drone)

    "consumable":
      match reward.key:
        "heal-all":
          player.heal(10.0)
