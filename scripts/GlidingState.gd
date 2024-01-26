extends State
class_name GlidingState
const GLIDING_SPEED = 100
	
func state_input(event: InputEvent):
	
	if event.is_action_pressed("jump") or event.is_action_pressed("sprint"):
		transition_to.emit("Air")


func on_enter():
	
	tree.get("parameters/playback").travel("Glide")


func update(delta):
	if character.is_on_floor():
		transition_to.emit("Ground")
		return
		
	if character.direction:
		tree.set("parameters/Glide/blend_position", character.direction)
	
	character.velocity.y =  GLIDING_SPEED*0.5 
	character.velocity.x = clampf(character.velocity.x, -GLIDING_SPEED, GLIDING_SPEED)
