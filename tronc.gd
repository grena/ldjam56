extends Sprite2D

# Variables pour le shake
@export var shake_intensity = 5.0  # L'intensité du shake (en pixels)
@export var shake_duration = 0.2  # Durée du shake (en secondes)
var shake_timer = 0.0

func _process(delta: float) -> void:
	# Si le shake est actif
	if shake_timer > 0:
		# Réduire le timer
		shake_timer -= delta

		# Appliquer un déplacement aléatoire sur l'axe X
		var random_offset = randf_range(-shake_intensity, shake_intensity)
		position.x += random_offset
		
		# Remettre le sprite à sa position d'origine après le shake
		await get_tree().create_timer(0.02).timeout
		position.x -= random_offset

# Fonction pour démarrer le shake
func start_shake():
	shake_timer = shake_duration  # Démarrer le shake pour la durée spécifiée
