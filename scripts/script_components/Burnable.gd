extends Area2D
class_name Burnable
@export var body : Node2D
var collider : CollisionShape2D
@export var burning : bool = false
var particles : GPUParticles2D
var temperature : float = 60
var burn_timer = 1.0
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
	if !burning:
		burning = true
		burn_timer = 1.0


func put_out():
	if burning:
		burn_timer = 1.0
		burning = false
	
	
func on_burnable_body_entered(body):
	if body.is_in_group("Meltable") and self.burning:
		var meltable_component : Meltable = body.get_node("Meltable")
		meltable_component.melt(self.temperature)
	elif body.is_in_group("Burnable") and self.burning:
		var burnable_component : Burnable = body.get_node("Burnable")
		burnable_component.burn()

	
		
func on_burnable_body_exited(body):
	if body.is_in_group("Meltable") and burning:
		var meltable_component : Meltable = body.get_node("Meltable")
		meltable_component.melt(-self.temperature)
	elif body.is_in_group("Burnable"):
		var burnable_component : Burnable = body.get_node("Burnable")
		if burnable_component.burn_timer > 0 :
			burnable_component.put_out()


func _process(delta):
	if !particles.emitting and burning:
		burn_timer -= delta
	elif !burning and particles.emitting:
		put_out()
		
	particles.emitting = burn_timer < 0
