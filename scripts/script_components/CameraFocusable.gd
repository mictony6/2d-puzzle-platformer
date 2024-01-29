extends Node2D
class_name CameraFocusable

@export var focused : bool = false
var body : PhysicsBody2D
# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_parent()
	body.add_to_group("CameraFocusable")
	body.set_collision_layer_value(7, true)

func focus():
	focused = true

func unfocus():
	focused = false

