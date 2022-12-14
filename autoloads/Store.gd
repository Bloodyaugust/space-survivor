extends Node

signal reward_chosen(reward)
signal state_changed(state_key, substate)

var persistent_store:PersistentStore
var state: Dictionary = {
  "client_view": "",
  "game": "",
  "debug": true,
  "kills": 0,
  "level": 1,
  "level_progress": 0,
  "rewards": [],
 }

func start_game() -> void:
  set_state("client_view", ClientConstants.CLIENT_VIEW_NONE)
  set_state("game", GameConstants.GAME_STARTING)

  yield(get_tree().create_timer(0.5), "timeout")
  call_deferred("set_state", "game", GameConstants.GAME_IN_PROGRESS)

func save_persistent_store() -> void:
  if ResourceSaver.save(ClientConstants.CLIENT_PERSISTENT_STORE_PATH, persistent_store) != OK:
    print("Failed to save persistent store")

func set_state(state_key: String, new_state) -> void:
  state[state_key] = new_state
  emit_signal("state_changed", state_key, state[state_key])
  print("State changed: ", state_key, " -> ", state[state_key])
  
func _initialize():
  if state.debug:
    start_game()
  else:
    set_state("client_view", ClientConstants.CLIENT_VIEW_SPLASH)
    set_state("game", GameConstants.GAME_OVER)

func _ready():
  if Directory.new().file_exists(ClientConstants.CLIENT_PERSISTENT_STORE_PATH):
    persistent_store = load(ClientConstants.CLIENT_PERSISTENT_STORE_PATH)

  if !persistent_store:
    persistent_store = PersistentStore.new()
    save_persistent_store()

  call_deferred("_initialize")
