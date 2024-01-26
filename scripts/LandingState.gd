extends State
class_name LandingState

var LANDING_SPEED_X = 25
var sprint_land : bool = false


func on_enter():
	if character.is_sprinting:
		sprint_land =  true
	else:
		sprint_land = false
	tree.get("parameters/playback").travel("Land")
func coyote_jump():
	character.jump()
func update(delta):
	
	
	if character.coyote_time > 0 && Input.is_action_just_pressed("jump"):
		coyote_jump()
	character.coyote_time -=delta
		
	if sprint_land:
		LANDING_SPEED_X = 50
	else:
		LANDING_SPEED_X = 25
	if character.is_on_floor():
		transition_to.emit("Ground")
	else:
		character.velocity.y += character.gravity * delta
		character.velocity.x = clampf(character.velocity.x, -LANDING_SPEED_X, LANDING_SPEED_X)


