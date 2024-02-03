extends Node2D
@export var top : StaticBody2D 
var area : Area2D
var bodies_on_top = []
var pushing_down : bool = false
var down_pos : float
var up_pos : float

var cumulative_weight : float = 0.0


func _ready():
	area = $Area2D
	area.body_entered.connect(_on_body_entered_area)
	area.body_exited.connect(_on_body_exited_area)
	down_pos = top.position.y+8
	up_pos = top.position.y

func _process(delta):

	pushing_down = cumulative_weight >= 5

	if pushing_down and top.position.y <= down_pos:
		top.move_and_collide(Vector2(0, 64*delta))
		# top.position = top.position.move_toward(Vector2(top.position.x, down_pos), 64*delta)
	elif !pushing_down:
		top.position = top.position.move_toward(Vector2(top.position.x, up_pos), 24*delta)



func _on_body_entered_area(body):
	if body.is_in_group("Movable") or body is Player:
		bodies_on_top.push_back(body)
		cumulative_weight += body.mass



func _on_body_exited_area(body):
	if bodies_on_top.has(body):
		bodies_on_top.erase(body)
		cumulative_weight -= body.mass
