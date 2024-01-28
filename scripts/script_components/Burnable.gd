extends Area2D
class_name Burnable
@export var body : Node2D
var collider : CollisionShape2D
@export var burning : bool = false
var particles : GPUParticles2D
# Called when the node enters the scene tree for the first time.
func _ready():
	particles = $GPUParticles2D
	if !body:
		body = get_parent()
	body.add_to_group("Burnable")
	collider = get_child(1)
	
	body_entered.connect(on_burnable_body_entered)
	body_exited.connect(on_burnable_body_exited)
	
	
func burn():
	$GPUParticles2D.emitting = true
	burning = true

func put_out():
	$GPUParticles2D.emitting = false
	burning = false
	
	
func on_burnable_body_entered(body):
	if body.is_in_group("Meltable") and burning:
		var meltable_component : Meltable = body.get_node("Meltable")
		meltable_component.melt(meltable_component.melting_threshold)
	elif body.is_in_group("Burnable") and burning:
		var burnable_component : Burnable = body.get_node("Burnable")
		burnable_component.burn()
		
func on_burnable_body_exited(body):
	if body.is_in_group("Meltable") and burning:
		var meltable_component : Meltable = body.get_node("Meltable")
		meltable_component.melt(meltable_component.melting_threshold-1)


func _process(delta):

	if !particles.emitting and burning:
		burn()
	elif !burning and particles.emitting:
		put_out()
