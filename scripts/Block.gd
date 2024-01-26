extends RigidBody2D
class_name Block

@export var push_multiplier : float = 1.0
@export  var launch_multiplier : float = 1.0



func push(impulse:Vector2):
	apply_central_impulse(impulse*push_multiplier)
	
func launch(launch_details):
	apply_central_impulse(launch_details.force * launch_details.direction * launch_multiplier)  # Apply impulse at collision point

