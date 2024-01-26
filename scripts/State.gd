extends Node
class_name State

@export var can_move : bool = true
@export var can_glide : bool = false
@export var can_sprint : bool = false
@export var can_push : bool = false

var character : Player
var next_state : State
var tree : AnimationTree

signal transition_to(signal_name)

func state_input(event):
	pass

func on_enter():
	pass
	
func on_exit():
	pass
func update(delta):
	pass

