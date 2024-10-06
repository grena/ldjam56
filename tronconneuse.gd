extends Sprite2D

func _ready() -> void:
	start_shake_and_squish()

func start_shake_and_squish():
	var original_scale = scale
	var scale_variation = 0.015
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(original_scale.x + scale_variation, original_scale.y - scale_variation), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(original_scale.x, original_scale.y), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(Callable(self, "_on_tween_finished"))

func _on_tween_finished() -> void:
	start_shake_and_squish()
