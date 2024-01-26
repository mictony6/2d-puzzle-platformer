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

#sprint
var is_sprinting : bool = false

func _ready():
	default_position =  position
	state_machine = $CharacterStateMachine
	ability_particles = $GPUParticles2D
	ability_ray = $ability_ray


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
	velocity.y = JUMP_VELOCITY 
	state_machine.current_state.transition_to.emit("Air")
	
func get_launched(launch_direction : Vector2):
	state_machine.current_state.transition_to.emit("Air")
	velocity.x = 250*3*launch_direction.x	
	velocity.y = 250*3*launch_direction.y
	
	
	
