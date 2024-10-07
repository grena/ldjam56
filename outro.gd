extends Node2D

func _ready() -> void:
	pass
	#launch_outro()

# Called when the node enters the scene tree for the first time.
func launch_outro() -> void:
	var tween_fade_in = create_tween()

	var fade_in_duration = 3.0
	var target_color = Color(0, 0, 0, 1.0)
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property($CanvasLayer/ColorRect, "color", target_color, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	fade_in_tween.tween_callback(Callable(self, "_on_ecran_tout_noir"))
	
func _on_ecran_tout_noir() -> void:
	hide_objects()
	
	var fade_in_duration = 3.0
	var target_color = Color(0, 0, 0, 0.0)
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property($CanvasLayer/ColorRect, "color", target_color, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	fade_out_tween.tween_callback(Callable(self, "_on_ecran_visible"))
	
func _on_ecran_visible() -> void:
	get_parent().get_node("Player").get_node("JackDitGoPlayer").play()
	
	var fusee = get_parent().get_node("Fusee")
	fusee.decollage()
	
	# Dezoom caméra
	
func hide_objects() -> void:
	# tout masquer
	get_parent().get_node("GUI").get_node("TextureRect").visible = false
	get_parent().get_node("Player").visible = false
	get_parent().get_node("Tubes").visible = false
	get_parent().get_node("Player").get_node("AspibroyeurPlayer").stop()
