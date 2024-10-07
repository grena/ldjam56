extends TextureRect

@onready var XRayRemoveBlob: Timer = $XRayRemoveBlob
@onready var XRayAlpha: Timer = $XRayAlpha
@onready var Texture1 = preload('res://assets/xray1.png')
@onready var Texture2 = preload('res://assets/xray2.png')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var blobs = [Texture1, Texture2]
	var i = randi_range(0, blobs.size() - 1)
	self.texture = blobs[i]
	self.rotation = randi_range(0, 3) * PI / 2
	$XRayRemoveBlob.start();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var flash_percentage = XRayRemoveBlob.time_left / XRayRemoveBlob.wait_time;
	var modulate = 1.0
	if flash_percentage >= 0:
		modulate = 1.0 + flash_percentage * 2.5
	self.modulate.r = modulate;
	self.modulate.g = modulate;
	self.modulate.b = modulate;
	
	var alpha = 1.0
	if !XRayAlpha.is_stopped():
		var alpha_percentage = XRayAlpha.time_left / XRayAlpha.wait_time;
		alpha = alpha_percentage
		self.modulate.a = alpha

func _on_x_ray_remove_blob_timeout() -> void:
	XRayAlpha.start()

func _on_x_ray_alpha_timeout() -> void:
	self.queue_free();
	
