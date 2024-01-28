extends State
class_name GroundState

var local_jump_velocity : int = 0


func on_enter():

	character.launched = false
	walk()
	if (Input.is_action_pressed("sprint")):
		sprint()
	tree.get("parameters/playback").travel("Ground")

	
func state_input(event : InputEvent):

	if (event.is_action_pressed("jump")):
		character.jump()
	if (event.is_action_pressed("sprint")):
		sprint()
	elif (event.is_action_released("sprint")):
		walk()
	if (event.is_action_pressed("ability")):
		activate_ability()
		
func sprint():
	character.is_sprinting = true;
func walk():
	character.is_sprinting = false;
	
func update(delta):
	if character.buffered_jump_timer > 0:
		character.jump()
		return
	tree.set("parameters/Ground/blend_position", character.direction)
	tree.set("parameters/Sprinting/blend_position", character.direction)
	
	#sprinting animation and logic
	if character.is_sprinting:
		character.velocity.x = character.velocity.x*1.2
		tree.get("parameters/playback").travel("Sprinting")
	else:
		tree.get("parameters/playback").travel("Ground")
	
	if !character.is_on_floor():
		transition_to.emit("Landing")
		return
		

		
func on_exit():
	character.coyote_time = 0.1
	
func activate_ability():
	tree.get("parameters/playback").travel("Ground")
	transition_to.emit("Ability")
	return

