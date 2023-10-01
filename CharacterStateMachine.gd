extends Node
class_name CharacterStateMachine

var states : Array[State]
@export var character : Player
@export var label : Label
@export var current_state : State
func _ready():
	for child in get_children():
		print(child)
		if (child is State):
			states.append(child)
			child.character = character
		else:
			push_warning("Child "+child.name+" is not a State.")

func _input(event):
	current_state.state_input(event)

func check_can_move():
	return current_state.can_move

func _physics_process(delta):
	current_state.update(delta)
		
	if (current_state.next_state != null):
		switch_state(current_state.next_state)
		
	label.text = str(current_state.name)
	
func switch_state(new_state):
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()	
