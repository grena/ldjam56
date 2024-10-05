extends Node2D

class_name FriskyTree

# Vitesse du curseur (peut être ajustée)
const CURSOR_SPEED = 1.0

# Références vers les MeshInstance2D
var cursor : MeshInstance2D
var success_zone : MeshInstance2D

# Direction du mouvement du curseur
var moving_right = true
var cursor_valid = false

func _ready() -> void:
	# Récupérer les références des MeshInstance2D
	cursor = $MiniJeu/Cursor
	success_zone = $MiniJeu/SuccessZone

func _process(delta: float) -> void:
	# Déplacer le curseur
	move_cursor(delta)

	# Vérifier si l'utilisateur appuie sur "espace"
	if Input.is_action_just_pressed("ui_accept"):
		check_success()

# Fonction pour déplacer le curseur de droite à gauche
func move_cursor(delta: float) -> void:
	var cursor_position = cursor.position

	# Si le curseur va vers la droite
	if moving_right:
		cursor_position.x += CURSOR_SPEED * delta
		# Si le curseur atteint le bord droit du MiniJeu, changer de direction
		if cursor_position.x >= 0.5:
			moving_right = false
	# Si le curseur va vers la gauche
	else:
		cursor_position.x -= CURSOR_SPEED * delta
		# Si le curseur atteint le bord gauche du MiniJeu, changer de direction
		if cursor_position.x <= -0.5:
			moving_right = true

	# Appliquer la nouvelle position
	cursor.position = cursor_position

# Fonction pour vérifier si le curseur est dans la zone de succès
func check_success() -> void:
	if cursor_valid:
		print('BRAVO !')
	else:
		print('NUL !')

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == cursor:
		cursor_valid = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() == cursor:
		cursor_valid = false
