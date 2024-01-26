extends StaticBody2D

var is_up: bool = false
var launchForce: float = 5000.0  # Adjust this value based on the desired force
var area : Area2D
var launch_direction = Vector2(0, -1)  # Adjust the direction as needed


var bodies_on_top   = []
var player_on_top : Player

func _ready():
	area = $Sprite2D/Area2D
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)
	

func up():
	is_up = true

func down():
	is_up = false
	
func on_body_entered(body):
	if body is RigidBody2D:
		bodies_on_top.append(body)
	elif body is CharacterBody2D:
		player_on_top = body

func on_body_exited(body):
	if body is CharacterBody2D:
		player_on_top = null
	elif bodies_on_top.has(body):
		bodies_on_top.erase(body)


func _physics_process(delta):
		# Check if the overlapping body is a RigidBody2D and the StaticBody2D is up
	if is_up:
		# Apply a force to launch the RigidBody2D upwards
		for body in bodies_on_top:
			var launch_details = {
				'force':launchForce,
				'direction': launch_direction
			}
			body.launch(launch_details)
		bodies_on_top.clear()
		if player_on_top != null:
			player_on_top.get_launched(launch_direction)
		player_on_top=null
		down()
			

