extends Node2D

@export var push_multiplier : float = 1.0
@export var body : RigidBody2D = null

func _ready():
	if !body:
		body = get_parent()
	body.add_to_group("Pushable")
	
func push(impulse:Vector2):

	body.apply_central_impulse(impulse*push_multiplier)
