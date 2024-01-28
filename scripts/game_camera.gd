extends Camera2D
const max_h_offset : int = 16

var follow_player_y = true
const follow_offset = 15

@export var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var top_threshold : float = get_screen_center_position().y -25
	var bottom_threshold : float = get_screen_center_position().y + 60
	var players_direction = player.velocity.normalized()
	var x_factor = 1 if players_direction.x > 0 else -1  
	if players_direction.x != 0:
		offset = offset.move_toward( Vector2(x_factor* max_h_offset,offset.y), 75*delta)
	position.x = player.position.x
	
	if player.position.y > bottom_threshold or player.position.y < top_threshold:
		follow_player_y = true
		
	if follow_player_y:
		#position = position.move_toward(Vector2(position.x,\
		 #player.position.y-follow_offset), 50*delta)
		position = position.lerp(Vector2(position.x, player.position.y-follow_offset), delta)
		if abs(position.y - (player.position.y-follow_offset)) < 24:
			follow_player_y = false
	

	
