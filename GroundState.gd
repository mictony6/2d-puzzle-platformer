extends State
class_name GroundState
@export var air_state : State

func state_input(event : InputEvent):
	if (event.is_action_pressed("jump")):
		jump()
		
func jump():
	character.velocity.y = character.JUMP_VELOCITY
	next_state = air_state
	
func update(delta):
	pass
