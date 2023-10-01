extends State
class_name AirState

@export var ground_state : State
var jump_x = 0

func on_enter():
	if character.direction != 0:
		jump_x = 300*character.direction
	else :
		jump_x = 0
		
func update(delta):
	jump_x =lerpf(jump_x, 0, 0.025)
	character.velocity.x = jump_x
	if character.is_on_floor():
		next_state = ground_state
