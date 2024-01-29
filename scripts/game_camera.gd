extends Camera2D
const max_h_offset : int = 16

var follow_player_y = true
const follow_offset = 16

var area : Area2D

var distance_between : float
var prev_distance_between : float
@export var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	area = $Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):



	if Input.is_action_pressed("focus"):
		var focusable : CameraFocusable = find_focusable()
		if focusable:
			focus_on(focusable, delta)
		return
	if zoom != Vector2(2.5, 2.5):
		zoom = zoom.move_toward(Vector2(2.5, 2.5), delta)
	var top_threshold : float = position.y -24
	var bottom_threshold : float = position.y + 60
	var players_direction = player.velocity.normalized()
	var x_factor = 1 if players_direction.x > 0 else -1  
	if players_direction.x != 0:
		offset = offset.move_toward( Vector2(x_factor* max_h_offset,offset.y), 75*delta)
	position.x = move_toward(position.x, player.position.x, 250*delta)
	
	if player.position.y > bottom_threshold or player.position.y < top_threshold:
		follow_player_y = true
		
	if follow_player_y:
		#position = position.move_toward(Vector2(position.x,\
		 #player.position.y-follow_offset), 50*delta)
		position = position.lerp(Vector2(position.x, player.position.y-follow_offset), delta)
		if abs(position.y - (player.position.y-follow_offset)) < 1:
			follow_player_y = false
	#

func find_focusable():
	if area.get_overlapping_bodies().size() > 0:
		var f : CameraFocusable = area.get_overlapping_bodies()[0].get_node("CameraFocusable")
		if f.focused:
			return f 

	return null
	
func focus_on(focusable : CameraFocusable, delta: float):
	distance_between = (focusable.global_position-player.position).length_squared()
	var target :Vector2 = (lerp(player.position, focusable.global_position, 0.5))
	
	position = position.move_toward(target, 250*delta)
	distance_between = floori(distance_between)
	var zoom_out = distance_between > 40000 and ((distance_between - prev_distance_between) > 1000) 
	var zoom_in = (prev_distance_between - distance_between > 1000)
	
	print(distance_between, prev_distance_between)
	if zoom_out:
		zoom = zoom.move_toward(Vector2.ONE, delta)
	elif zoom_in:
		zoom = zoom.move_toward(Vector2(2.5, 2.5), delta)
	prev_distance_between = distance_between
