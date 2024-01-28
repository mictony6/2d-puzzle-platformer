extends State
class_name AirState

var jump_x = 0
var sprint_jump : bool = false


func on_enter():
	#for child in ceiling_slide_rays.get_children():
		#child.enabled = true
	character.buffered_jump_timer = 0
	character.glide_checker.enabled = true
	if character.is_sprinting:
		sprint_jump =  true
	else:
		sprint_jump = false
	tree.get("parameters/playback").travel("Air")
	if sprint_jump:
		jump_x = character.SPEED*1.2*character.direction
	else:
		jump_x =character.SPEED*character.direction
	if character.launched:
		jump_x = character.velocity.x
		sprint_jump = true
		
func update(delta):
	if Input.is_action_just_pressed("jump"):
		character.buffered_jump_timer = character.buffered_jump_time
	if character.glide_checker.enabled:
		can_glide = !character.glide_checker.is_colliding()
	if character.direction:
		tree.set("parameters/Air/blend_position", character.direction)
	
	if sprint_jump:
		jump_x =lerpf(jump_x, 0, 0.005)
	else:
		jump_x =lerpf(jump_x, 0, 0.025)		
		
	character.velocity.x = jump_x 
	if character.is_on_floor() and character.velocity.y >= 0:
		transition_to.emit("Ground")
	else:
		character.velocity.y += character.gravity * delta
	
	if character.velocity.y >= 320 :
			transition_to.emit("Landing")
			return
		
func on_exit():
	#for child in ceiling_slide_rays.get_children():
		#child.enabled = false
	character.coyote_time = 0
	character.glide_checker.enabled = false

