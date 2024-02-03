extends Node2D
class_name Meltable

@export var sprite : Sprite2D
@export var collider : CollisionShape2D

@export var melting_threshold : float = 60
var current_temperature : float = 50
var melting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().add_to_group("Meltable")
	if current_temperature >= melting_threshold:
		melting = true


func melt(temperature: float):
	if !melting:
		current_temperature = temperature
	else:
		current_temperature += temperature*0.5
	print(current_temperature)
	melting =  temperature >= melting_threshold
	
func _process(delta):
	if melting:
		# Calculate the scale reduction based on the temperature
		var scale_ratio =  1- current_temperature * 0.0005 * delta
		sprite.scale *= scale_ratio
		
		
		# Ensure the scale does not become negative or zero
		sprite.scale.x = max(0.0, sprite.scale.x)
		sprite.scale.y = max(0.0, sprite.scale.y)
		
		collider.scale *= scale_ratio
		collider.scale.x = max(0.0, collider.scale.x)
		collider.scale.y = max(0.0, collider.scale.y)
#
		 #Add any additional logic specific to the melting state here
		 #For example, emit a signal, play a particle effect, etc.
#
		# Check if the object has completely melted
		if collider.scale.length_squared() < 0.25:
			# Perform actions when the object is completely melted
			print("Object has melted completely.")
			# Remove or free the object as needed
			melting = false  # Reset the melting state
