extends Node2D

@export var speed = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += speed * delta
	if is_equal_approx($Path2D/PathFollow2D.progress_ratio, 1) && $TimerGrounded && $TimerGrounded.is_stopped():
		print_debug('Start')
		$TimerGrounded.start();

	if (!$TimerDisappear.is_stopped()):
		self.modulate.a = $TimerDisappear.time_left / 3.0

func _on_timer_grounded_timeout() -> void:
	$TimerGrounded.queue_free();
	$TimerDisappear.start();

func _on_timer_disappear_timeout() -> void:
	self.queue_free();
