extends CharacterBody2D

class_name Player


const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const FRICTION = 0.01
var direction
@onready
var state_machine : CharacterStateMachine = $CharacterStateMachine

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction && state_machine.check_can_move():
		velocity.x = direction * SPEED
	else:
		# move towards zero at SPEED rate
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
