extends CanvasLayer

var velocity_min = 3
var velocity_on_mixage = 50
var velocity = velocity_min

var rota = 0
var max_y = 12
var shouldDisplayXRay = true
var remplissage

func set_remplissage(percentage: float):
	remplissage = percentage
	$Node2D/Fuel/Fuel.position.y = -300 * percentage
	$Node2D/Fuel/ColorRect.position.y = 100 + -250 * percentage
	($Node2D/Fuel/ColorRect as ColorRect)._set_size(Vector2(2000, 250 * percentage))

func set_sound_on():
	$Node2D/SoundOn.set_visible(true)

func set_translator_on():
	$Node2D/TranslatorOn.set_visible(true)
	
func set_xray_on():
	$Node2D/XRayOn.set_visible(true)
	$Node2D/XRayMid.set_visible(true)
	
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

func run_mixer():
	velocity += velocity_on_mixage
	if remplissage > 0.75:
		display_blob()

func display_blob():
	var blobs = [$Node2D/XRay1, $Node2D/XRay2]
	var i = randi_range(0, blobs.size() - 1)
	var blob: TextureRect = blobs[i]
	blob.set_visible(true)
	blob.rotation = randi_range(0, 3) * PI / 2
	$XrayRemoveBlob.start();

func _on_x_ray_mid_change_timeout() -> void:
	$Node2D/XRayMid.rotation += PI/2

# FOR DEBUG
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		run_mixer();

func _on_xray_remove_blob_timeout() -> void:
	$Node2D/XRay1.set_visible(false);
	$Node2D/XRay2.set_visible(false);
