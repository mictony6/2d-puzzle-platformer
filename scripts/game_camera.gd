extends Camera2D
const max_h_offset : int = 16

var follow_player_y = true
const follow_offset = 16

var area : Area2D

var distance_between : float
var prev_distance_between : float
@export var player : Player
var custom_offset : Vector2

var fo_in_view = []
var focused_body : CameraFocusable = null

var focus_timer: float = 0.0
var focus_switch_delay: float = 0.2	
func _ready():
	area = $Area2D
	area.body_entered.connect(on_body_in_view)
	area.body_exited.connect(on_body_exited_view)

func on_body_in_view(body):
	#var index = 0
	#var inserted = false
	#for i in range(fo_in_view.size()):
		#var o : Node2D = fo_in_view[i]
		#var o_distance = o.position.distance_squared_to(player.position) 
		#var body_distance = body.position.distance_squared_to(player.position)
		#if body_distance < o_distance:
			#if fo_in_view.size() == 1:
				#fo_in_view.push_front(body)
			#else:
				#fo_in_view.insert(i, body)
			#inserted =true
	#if !inserted:
		#fo_in_view.push_back(body)
	fo_in_view.push_back(body)
	
func on_body_exited_view(body):
	if fo_in_view.has(body):
		fo_in_view.erase(body)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if zoom != Vector2(2.5, 2.5) and zoom > Vector2.ONE:
		area.scale = (Vector2(2.5/zoom.x, 2.5/zoom.y))
	
	if Input.is_action_just_released("focus"):
		focused_body = null
	if Input.is_action_pressed("focus"):
		if !focused_body:
			focused_body = find_focusable()
		elif focused_body:
			focus_on(focused_body, delta)
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
	
	follow_player_y = player.position.y > bottom_threshold or player.position.y < top_threshold
		
	if follow_player_y:
		#position = position.move_toward(Vector2(position.x,\
		 #player.position.y-follow_offset), 50*delta)
		position = position.lerp(Vector2(position.x, player.position.y-follow_offset), delta)
		follow_player_y = abs(position.y - (player.position.y-follow_offset)) < 1

	area.global_position =  position+offset

func find_focusable():
	if fo_in_view.size() > 0:
		var body_closest = get_body_closest_to_player()
		var f : CameraFocusable = body_closest.get_node("CameraFocusable")
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

	if zoom_out:
		zoom = zoom.move_toward(Vector2.ONE, delta)
	elif zoom_in:
		zoom = zoom.move_toward(Vector2(2.5, 2.5), delta)
	prev_distance_between = distance_between

func get_body_closest_to_player() -> Node2D:
	if fo_in_view.is_empty():
		return null

	fo_in_view.sort_custom(_compare_distance)
	return fo_in_view[0]

func _compare_distance(a, b):
	var distance_a = a.global_position.distance_to(player.position)
	var distance_b = b.global_position.distance_to(player.position)

	return distance_a < distance_b
	
