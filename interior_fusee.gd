extends CanvasLayer

@onready var XRayScene = preload('res://x_ray.tscn')
@onready var FlashGlobal: Polygon2D = $Node2D/Polygon2D
@onready var FlashGlobalTimer: Timer = $FlashGlobalTimer;

var velocity_min = 3
var velocity_on_mixage = 50
var velocity = velocity_min

var rota = 0
var max_y = 12
var shouldDisplayXRay = false
var remplissage

func led_is_blinking_when_starting(led):
	var number_of_blinks = 59
	var duration_blink = 0.2
	var blink_visible = true
	for x in number_of_blinks:
		# blink light
		var timer: Timer = Timer.new()
		timer.wait_time = duration_blink * x;
		timer.one_shot = true;
		timer.connect('timeout', func ():
			led.set_visible(blink_visible)
			timer.stop();
			timer.queue_free();
		);
		add_child(timer);
		timer.start();
		blink_visible = !blink_visible

func set_remplissage(percentage: float):
	remplissage = percentage
	$Node2D/Fuel/Fuel.position.y = -300 * percentage
	$Node2D/Fuel/ColorRect.position.y = 100 + -250 * percentage
	($Node2D/Fuel/ColorRect as ColorRect)._set_size(Vector2(2000, 250 * percentage))

func set_sound_on():
	led_is_blinking_when_starting($Node2D/SoundOn)
 
func set_translator_on():
	led_is_blinking_when_starting($Node2D/TranslatorOn)
	
func set_xray_on():
	led_is_blinking_when_starting($Node2D/XRayOn)
	led_is_blinking_when_starting($Node2D/XRayMid)
	
func set_display_blobs_in_xray():
	shouldDisplayXRay = true

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
	
	FlashGlobal.modulate.a = FlashGlobalTimer.time_left / FlashGlobalTimer.wait_time

func run_mixer():
	velocity += velocity_on_mixage
	if shouldDisplayXRay:
		display_blob()
	if remplissage > randi_range(0, 80):
		$Node2D/CPUParticles2D.emitting = true

func display_blob():
	var xray = XRayScene.instantiate();
	$Node2D.add_child(xray);
	FlashGlobalTimer.start();

func _on_x_ray_mid_change_timeout() -> void:
	$Node2D/XRayMid.rotation += PI/2
	

# FOR DEBUG
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton:
#		run_mixer();

func has_cut_tree():
	$Node2D/FuseeWindow.has_cut_tree();
