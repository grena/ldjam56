extends Sprite2D

# Amplitude du balancement (en degrés)
var wind_amplitude: float = 1.0

# Délai de démarrage pour que chaque arbre ait un cycle décalé
var start_delay: float = 0.0

func _ready() -> void:
	var rand_delay = randf_range(0, 3)
	# Démarrer l'effet de balancement après un délai pour créer un décalage
	await get_tree().create_timer(rand_delay).timeout
	start_wind_effect()

func start_wind_effect():
	var tween = create_tween()

	# Utiliser la variable `wind_amplitude` pour contrôler la rotation
	tween.tween_property(self, "rotation_degrees", wind_amplitude, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", -wind_amplitude, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Boucler l'effet de balancement
	tween.tween_callback(Callable(self, "_on_wind_effect_finished"))

func _on_wind_effect_finished():
	# Relancer l'effet de vent pour un balancement continu
	start_wind_effect()
