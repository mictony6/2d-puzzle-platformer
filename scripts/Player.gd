extends CharacterBody2D
class_name Player



const SPEED = 100.0
const JUMP_VELOCITY = -250.0
const FRICTION = 0.01
var direction 
@onready
var state_machine : CharacterStateMachine 
var ability_ray : RayCast2D
var ability_particles : GPUParticles2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var default_position : Vector2

#coyote time
var coyote_time = 0.1

#jump buffer
var buffered_jump_time = 0.1
var buffered_jump_timer = 0.0

var launched : bool = false

#sprint
var is_sprinting : bool = false

var glide_checker : RayCast2D 


@onready var inner_right : RayCast2D = $ceiling_slide_rays/right_inner
@onready var inner_left : RayCast2D = $ceiling_slide_rays/left_inner
@onready var outer_right : RayCast2D = $ceiling_slide_rays/right_outer
@onready var outer_left : RayCast2D = $ceiling_slide_rays/left_outer



func _ready():
	default_position =  position
	state_machine = $CharacterStateMachine
	ability_particles = $GPUParticles2D
	ability_ray = $ability_ray
	glide_checker = $glide_check


func _process(delta):
	pass

func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	
	move_character(delta)
	
	
	state_machine.update_state_machine(delta)

	
	# reset for debugging
	if position.y > 500:
		position.y = default_position.y
		
	#terminal velocity
	velocity.y = clampf(velocity.y, -640.0, 320.0)
	
	$Control/HBoxContainer/VelocityLabel.text = "Velocity: " + str(velocity) 
	$Control/HBoxContainer/StateLabel.text = "State: " + state_machine.current_state.name
	move_and_slide()

	
func move_character(delta):
	if direction && state_machine.check_can_move():
		velocity.x = direction * SPEED 
	else:
		# move towards zero at SPEED rate
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

func jump():
	if outer_left.is_colliding() and !inner_left.is_colliding() \
		and !inner_right.is_colliding() and !outer_right.is_colliding():
			position.x += 5
	elif outer_right.is_colliding() and !inner_right.is_colliding() \
		and !inner_left.is_colliding() and !outer_left.is_colliding():
			position.x -= 5
			
	velocity.y = JUMP_VELOCITY 
	state_machine.current_state.transition_to.emit("Air")
	
func get_launched(launch_direction : Vector2):
	launched = true
	velocity.x = 250*3*launch_direction.x	
	velocity.y = 250*3*launch_direction.y
	direction = launch_direction.x
	state_machine.current_state.transition_to.emit("Air")
	
	
