extends Node2D


@export  var launch_multiplier : float = 1.0
@export var body : Node2D 


func _ready():
	if !body:
		body = get_parent()
	body.add_to_group("Launchable")
	
func launch(launch_details):
	if body is RigidBody2D:
		 # Apply impulse at collision point
		body.apply_central_impulse(launch_details.force * launch_details.direction * launch_multiplier) 
		

