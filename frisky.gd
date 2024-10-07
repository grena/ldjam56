extends Node2D
class_name Frisky

var terror_activated = false

func _ready() -> void:
	self.modulate.a = 0.8
	
func _process(delta: float) -> void:
	if !terror_activated:
		return
		
	self.set_z_index(self.global_position.y / 10 + 2000)

func is_afraid() -> void:
	if (terror_activated):
		return
	
	terror_activated = true
	
	var jumpTimer = Timer.new()
	jumpTimer.wait_time = randf_range(0.8, 3.0)
	jumpTimer.one_shot = false  # Le timer se répète
	jumpTimer.connect("timeout", Callable(self, "_on_jump_timeout"))
	jumpTimer.name = "JumpTimer"
	add_child(jumpTimer)
	jumpTimer.start()

func _on_jump_timeout() -> void:
	var move_time = randf_range(0.2, 0.7)
	var dist = 40
	var newPos = Vector2(self.position.x + randi_range(-dist, dist), self.position.y + randi_range(-dist, dist))
	
	var tween = create_tween()
	tween.tween_property(self, "position", newPos, move_time).set_ease(Tween.EASE_IN)
	
	var t = move_time
	var squishTween = create_tween()
	var original_scale = $Sprite2D.scale
	var squish_scale = Vector2(original_scale.x, original_scale.y * 0.5)
	squishTween.tween_property($Sprite2D, "scale", squish_scale, t / 2.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	squishTween.tween_property($Sprite2D, "scale", original_scale, t / 2.0).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
