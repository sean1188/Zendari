extends Node

const TIME_WARP = 0.3 # Factor in which time warps
const REWIND_FRAMERATE = 0.001
const RECORD_FRAMERATE = 0.05

var global_store = Dictionary() # Stores global state
var rewind_entities # Defines recorded attributes

var counter = 0.0

func _state_for(entity):
	return [entity.position, entity.enabled, entity.get_node('Sprite').animation]

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	rewind_entities = [$Player, $Key, $Door]
	for entity in rewind_entities: 
		global_store[entity] = [_state_for(entity)]
		pass
	pass

func _process(delta):
	counter += delta
	if counter > RECORD_FRAMERATE && !$Player.rewinding:
		for entity in rewind_entities:
			if _state_for(entity) != global_store[entity][-1]:
					global_store[entity].append(_state_for(entity))
					print("Recording", entity)
			pass 
		counter = 0
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed('player_rewind'):
		Engine.time_scale = TIME_WARP
	elif Input.is_action_just_released('player_rewind'):
		Engine.time_scale = 1.0
	if Input.is_action_pressed('player_rewind'):
		if counter > REWIND_FRAMERATE:
			for entity in rewind_entities:
				entity.rewinding = true
				if global_store[entity].size() == 1:
					print ("Playing back ", entity)
					var state = global_store[entity][0]
					entity.position = state[0]
					entity.enabled = state[1]
					entity.get_node('Sprite').animation = state[2]
					pass
				elif global_store[entity].size() > 1:
					print ("Playing back ", entity)
					var state = global_store[entity].pop_back()
					entity.position = state[0]
					entity.enabled = state[1]
					entity.get_node('Sprite').animation = state[2]
					pass
			counter = 0

	else:
		for entity in rewind_entities:
			entity.rewinding = false
			pass
			
