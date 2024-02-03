extends Node
class_name CharacterStateMachine

var states : Array[State]
@export var character : Player
@export var current_state : State
@export var animationtree : AnimationTree
func _ready():
	animationtree.active = true
	for child in get_children():
		print(child)
		if (child is State):
			states.append(child)
			child.character = character
			child.tree = animationtree
			child.transition_to.connect(_on_state_transition)
		else:
			push_warning("Child "+child.name+" is not a State.")

func _input(event : InputEvent):
	current_state.state_input(event)
	if (check_can_glide() && event.is_action_pressed("jump") ):
		current_state.next_state = $Gliding

func check_can_move():
	return current_state.can_move
	
func check_can_glide():
	return current_state.can_glide
	
func check_can_sprint():
	return current_state.can_sprint
	
	
func update_state_machine(delta):
	
	check_push(delta)
	character.buffered_jump_timer -= delta
	current_state.update(delta)

	if (current_state.next_state != null):
		switch_state(current_state.next_state)
		
func switch_state(new_state):
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()	
	
func _on_state_transition(new_state):
	print(new_state)
	current_state.next_state = get_node(new_state)

func check_push(delta):
	if (current_state.can_push):
		for i in range(character.get_slide_collision_count()):
			var collision : KinematicCollision2D = character.get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("Pushable"):
				var normal = -collision.get_normal()
				if (normal.y <= 0.1):
					collider.get_node("Pushable").push(normal.normalized() * 7500 * delta)
					

