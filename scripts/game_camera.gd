extends Camera2D
const max_h_offset : int = 50
@export var player : Player
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.velocity.normalized().x != 0:
		offset.x =  lerpf(offset.x, player.velocity.normalized().x * max_h_offset, delta)
	#else:
		#offset.x =  lerpf(offset.x, 0 * max_h_offset, delta)
		#offset.y =  lerpf(offset.y, player.velocity.normalized().y * max_h_offset, delta)
	position.x = player.position.x
