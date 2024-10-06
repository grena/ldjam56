extends CanvasLayer

var velocity_min = 3
var velocity_on_mixage = 50
var velocity = velocity_min

func _process(delta: float) -> void:
	$Node2D/MixerCenter.rotate(-delta * velocity)
	velocity = max(velocity * 0.95, velocity_min)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		velocity += velocity_on_mixage
