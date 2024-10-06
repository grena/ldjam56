extends CPUParticles2D

var shake_intensity = 5.0  # L'intensité du shake (en pixels)
var shake_duration = 20.0  # Durée du shake (en secondes)
var shake_timer = 0.0

var is_crashing = false

func _process(delta: float) -> void:
	# Si le shake est actif
	if shake_timer > 0:
		# Réduire le timer
		shake_timer -= delta

		# Appliquer un déplacement aléatoire sur l'axe X
		var random_offset = randf_range(-shake_intensity, shake_intensity)
		position.y += random_offset

		# Remettre le sprite à sa position d'origine après le shake
		await get_tree().create_timer(0.02).timeout
		position.y -= random_offset

# Fonction pour démarrer le shake
func start_shake():
	shake_timer = shake_duration  # Démarrer le shake pour la durée spécifiée

func toussoter():
	amount = 8
	scale_amount_min = 30
	scale_amount_max = 30
	color_ramp.colors.clear()
	color_ramp.add_point(0.0, Color(0.0, 0.0, 0.0, 1))
	color_ramp.add_point(0.0, Color(0.8, 0.8, 0.8, 1))

func crash():
	is_crashing = true
	var tween = create_tween()
	var crash_target_y = 800
	var crash_duration = 3
	# Démarrer l'animation du crash vers la position target Y
	tween.tween_property(self, "position:y", crash_target_y, crash_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	color_ramp.add_point(0.0, Color(0.0, 0.0, 0.0, 1))
	color_ramp.add_point(0.0, Color(0.2, 0.2, 0.2, 1))
