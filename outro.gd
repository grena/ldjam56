extends Node2D

var is_launched = false

func _ready() -> void:
	pass
	#launch_outro()
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_text_delete"):
		launch_outro()

# Called when the node enters the scene tree for the first time.
func launch_outro() -> void:
	if is_launched:
		return
		
	is_launched = true
	var tween_fade_in = create_tween()
	
	var UI_fusee = get_parent().get_node('GUI').get_node('TextureRect')

	var fade_in_duration = 3.0
	var target_color = Color(0, 0, 0, 1.0)
	var fade_in_tween = create_tween()
	fade_in_tween.tween_property($CanvasLayer/ColorRect, "color", target_color, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	fade_in_tween.tween_callback(Callable(self, "_on_ecran_tout_noir"))
	
	var move_ui_fusee_tween = create_tween()
	var ui_trans: Transform2D = UI_fusee.transform
	ui_trans.origin = Vector2(UI_fusee.transform.origin.x + 1000, UI_fusee.transform.origin.y)
	move_ui_fusee_tween.tween_property(UI_fusee, "transform", ui_trans, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
func _on_ecran_tout_noir() -> void:
	hide_objects()
	
	var fade_in_duration = 3.0
	var target_color = Color(0, 0, 0, 0.0)
	var fade_out_tween = create_tween()
	fade_out_tween.tween_property($CanvasLayer/ColorRect, "color", target_color, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	fade_out_tween.tween_callback(Callable(self, "_on_ecran_visible"))
	
func _on_ecran_visible() -> void:
	get_parent().get_node("Player").get_node("JackDitGoPlayer").play()
	var camera = get_parent().get_node("Player").get_node("Camera2D")
	
	var dezoom = create_tween()
	dezoom.tween_property(camera, "zoom", Vector2(0.3, 0.3), 10).set_ease(Tween.EASE_IN_OUT)
	
	var fusee = get_parent().get_node("Fusee")
	fusee.decollage()
	
	var timer: Timer = Timer.new()
	timer.wait_time = 12.0
	timer.one_shot = true;
	timer.connect('timeout', func ():
		var target_position: Vector2 = Vector2($CanvasLayer/RichTextLabel.position.x, $CanvasLayer/RichTextLabel.position.y - 1500)
		
		var display_credits = create_tween()
		display_credits.tween_property($CanvasLayer/RichTextLabel, "position", target_position, 40).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
		timer.stop();
		timer.queue_free();
	)
	
	add_child(timer)
	timer.start()
	
func hide_objects() -> void:
	# tout masquer
	get_parent().get_node("GUI").get_node("TextureRect").visible = false
	get_parent().get_node("Player").position = Vector2(-400, 0)
	get_parent().get_node("Player").visible = false
	get_parent().get_node("Tubes").visible = false
	get_parent().get_node("Player").get_node("AspibroyeurPlayer").stop()
