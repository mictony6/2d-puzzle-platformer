extends State
class_name AbilityState

@export var ability_cursor : Control
var cursor_area : Area2D
var selected_rigidbody : RigidBody2D

var cursor_speed : float = 150.0
const max_cursor_distance : float = 100
const max_cursor_distance_squared = max_cursor_distance*max_cursor_distance
const min_cursor_distance : float = 25;
const min_cursor_distance_squared = min_cursor_distance * min_cursor_distance;
var force_multiplier : float = 250.0

var bodies_selected = []

var controlling : bool = false


var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	cursor_area = ability_cursor.get_child(1)
	cursor_area.body_entered.connect(on_body_entered)
	cursor_area.body_exited.connect(on_body_exited)
	
func on_enter():
	character.ability_particles.emitting  = true
	reset_cursor_position()
	ability_cursor.visible = true
	cursor_area.monitoring = true
	character.ability_ray.enabled = true
	
func on_exit():
	character.ability_particles.emitting  = false
	character.ability_particles.position  = Vector2.ZERO	
	character.ability_ray.enabled = false	
	for body in bodies_selected:
		body.modulate = Color.WHITE
	bodies_selected.clear()
	ability_cursor.visible = false
	if selected_rigidbody:
		selected_rigidbody.angular_damp = 0
		selected_rigidbody.linear_damp = 0
		selected_rigidbody.gravity_scale = 1.0


	
	selected_rigidbody = null
	controlling =false
	cursor_area.monitoring = false
	
func reset_cursor_position():
	if character:
		ability_cursor.global_position = character.global_position

func state_input(event: InputEvent):
	if Input.is_action_just_pressed("ability"):
		if !controlling:
			select()
	if event.is_action_pressed("sprint"):
			transition_to.emit("Ground")
	if (event.is_action_pressed("jump")):
		jump()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta):
	
	if !character.is_on_floor():
		transition_to.emit("Landing")
		return
	
	direction = Input.get_vector("r_left", "r_right", "r_up", "r_down")
	
	
	if selected_rigidbody:
		move_selected_body(direction, delta)
	else:
	# Move the cursor based on the input direction
		move_cursor(direction, delta)
		

		
func jump():
	character.velocity.y = character.JUMP_VELOCITY 
	transition_to.emit("Air")

func move_cursor(direction, delta):

	# Calculate the new position based on the cursor speed and elapsed time
	var new_position : Vector2 = ability_cursor.position + direction * cursor_speed * delta
	var distance_to_player_squared = new_position.length_squared()
	if distance_to_player_squared > max_cursor_distance_squared:

		# Set the new cursor position
		new_position = new_position.normalized() * max_cursor_distance 
	elif distance_to_player_squared < min_cursor_distance_squared:
		new_position = new_position.normalized() * min_cursor_distance		
	ability_cursor.position = new_position
	character.ability_ray.target_position = ability_cursor.position

	# Check for obstruction and modulate green if can be reached otherwise red
	if bodies_selected.size() > 0:
		var body_on_cursor = bodies_selected[0]
		var ok_collision = (character.ability_ray.is_colliding() and character.ability_ray.get_collider() == body_on_cursor)
		if !character.ability_ray.is_colliding() or ok_collision :
			body_on_cursor.modulate = Color.GREEN
		else:
			body_on_cursor.modulate = Color.RED
	
	

func select():
	# if no bodies to select
	if bodies_selected.size() == 0:
		controlling = false	
		return
		
	# if theres in the way between the object anmd the player
	if character.ability_ray.is_colliding() and character.ability_ray.get_collider() != bodies_selected[0]:
		controlling = false
	else:
		character.ability_ray.enabled = false
		selected_rigidbody = bodies_selected[0]
		selected_rigidbody.angular_damp = 10
		selected_rigidbody.linear_damp = 5
		
		selected_rigidbody.gravity_scale = 0.0
		ability_cursor.visible = false
		controlling = true
		cursor_area.monitoring = false

func move_selected_body(direction, delta):

	# cancel if its pushing player up
	for i in range(character.get_slide_collision_count()):
		var collision =  character.get_slide_collision(i)
		if collision.get_collider() == selected_rigidbody and collision.get_normal().y < 0:
			transition_to.emit("Ground")
			return

	var movable_component :Movable = selected_rigidbody.get_node("Movable")
	movable_component.move(direction, force_multiplier, 200.0, delta)
	character.ability_particles.global_position = character.ability_particles.global_position.lerp(selected_rigidbody.global_position, delta*5) 
	

func on_body_entered(body):
	if body.is_in_group("Movable") :
		#if bodies_selected.size() == 0:
			#body.modulate = Color.GREEN
		#else: 
			#body.modulate = Color.WHITE
		bodies_selected.push_back(body)
		
func on_body_exited(body):
	if body in bodies_selected:
		body.modulate = Color.WHITE
		bodies_selected.erase(body)
		#if bodies_selected.size() > 0 :
			#bodies_selected[0].modulate = Color.GREEN	
	
