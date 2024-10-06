extends Node2D

class_name Bush

var bush_sprite_var1 : Sprite2D
var bush_sprite_var2 : Sprite2D
var bush_sprite_var3 : Sprite2D

var bush_sprite : Sprite2D
var original_color : Color
var original_scale = Vector2(1, 1)

var HEIGHT_VARIATION = 0.30
var COLOR_VARIATION = 0.3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprites = [$LdjamBuisson1, $LdjamBuisson2, $LdjamBuisson3]
	for i in sprites:
		i.visible = false
	bush_sprite = sprites[randi_range(0, 1)]
	bush_sprite.visible = true
	bush_sprite.scale.y += randf_range(0, HEIGHT_VARIATION)
	original_color = Color(1 - randf_range(0, COLOR_VARIATION), 1 - randf_range(0, COLOR_VARIATION), 1 - randf_range(0, COLOR_VARIATION), 1.0)
	bush_sprite.modulate = original_color
	original_scale = bush_sprite.scale

func tu_moisis() -> void:
   # Créer un Tween
	var tween = create_tween()
	var duration = 4.0
	# Animer l'échelle (scale) vers zéro (ratatinement)
	tween.tween_property(self, "scale", Vector2.ZERO, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	# Animer la transparence (modulate.a) vers zéro (disparition)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate", Color(0.55, 0.27, 0.07), duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		
	# Optionnel : libérer le sprite une fois l'animation terminée
	tween.tween_callback(Callable(self, "queue_free"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
