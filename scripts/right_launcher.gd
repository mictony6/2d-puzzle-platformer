extends Launcher
class_name RightLauncher


# Called when the node enters the scene tree for the first time.
func _ready():
	launch_direction = Vector2.RIGHT
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super._physics_process(delta)
