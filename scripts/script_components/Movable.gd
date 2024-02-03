extends Node2D
class_name Movable

var body : RigidBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	if !body:
		body = get_parent()
	body.add_to_group("Movable")
	body.set_collision_layer_value(2, true)
	body.set_collision_layer_value(1, false)
	body.set_collision_mask_value(2, true)
	body.set_collision_mask_value(1, true)

func move(direction:Vector2, force_multiplier:float, velocity_limit:float, _delta:float):


	var force = direction * force_multiplier


	if body.linear_velocity.length()  < velocity_limit :
		body.apply_central_impulse(force)