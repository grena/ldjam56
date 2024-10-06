extends CanvasLayer

var velocity_min = 3
var velocity_on_mixage = 50
var velocity = velocity_min

var rota = 0
var max_y = 12

func set_remplissage(percentage: float):
	$Node2D/Fuel/Fuel.position.y = -300 * percentage
	$Node2D/Fuel/ColorRect.position.y = 100 + -250 * percentage
	($Node2D/Fuel/ColorRect as ColorRect)._set_size(Vector2(2000, 250 * percentage))

func set_sound_on():
	$Node2D/SoundOn.set_visible(true)

func set_translator_on():
	$Node2D/TranslatorOn.set_visible(true)
	
func set_xray_on():
	$Node2D/XRayOn.set_visible(true)
	
	
func _ready() -> void:
	$Node2D/Fuel/ColorRect.position.y = 150
	$Node2D/Fuel/ColorRect.position.x = 50
	$Node2D/Fuel/ColorRect.position.y = 100
	($Node2D/Fuel/ColorRect as ColorRect)._set_size(Vector2(2000, 10))

func _process(delta: float) -> void:
	$Node2D/MixerCenter.rotate(-delta * velocity)
	velocity = max(velocity * 0.95, velocity_min)
	rota = rota + delta * 2
	$Node2D/Fuel/Fuel.position.x = cos(rota) * 50

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		velocity += velocity_on_mixage
		set_remplissage(1.0)
