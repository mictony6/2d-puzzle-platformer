extends StaticBody2D
class_name Launcher

var is_up: bool = false
var launchForce: float = 10000.0  # Adjust this value based on the desired force
var area : Area2D
var launch_direction : Vector2 = Vector2(0, -1)  # Adjust the direction as needed


var bodies_on_contact   = []
var player_on_contact : Player

func _ready():
	area = $Sprite2D/Area2D
	area.body_entered.connect(on_body_entered)
	area.body_exited.connect(on_body_exited)	

func up():
	is_up = true

func down():
	is_up = false
	
func on_body_entered(body):
	if body.is_in_group("Launchable"):
		bodies_on_contact.push_back(body)
	elif body is CharacterBody2D:
		player_on_contact = body

func on_body_exited(body):
	if body is CharacterBody2D:
		player_on_contact = null
	elif bodies_on_contact.has(body):
		bodies_on_contact.erase(body)


func _physics_process(delta):
	# Check if the overlapping body is a RigidBody2D and the StaticBody2D is up
	if is_up:
		# Apply a force to launch the Launchable component upwards
		for body in bodies_on_contact:
			var launch_details = {
				'force':launchForce,
				'direction': launch_direction
			}
			body.get_node("Launchable").launch(launch_details)
		bodies_on_contact.clear()
		if player_on_contact != null:
			player_on_contact.get_launched(launch_direction)
			player_on_contact = null
		# down()


