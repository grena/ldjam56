extends Node2D

class_name FriskyTree

# Vitesse du curseur (peut être ajustée)
var CURSOR_SPEED = 1.0

# Références vers les MeshInstance2D
var cursor : MeshInstance2D
var success_zone : MeshInstance2D
var mini_jeu : MeshInstance2D

var is_playing = false
var moving_right = true
var cursor_valid = false
var nb_success_required = 3
var nb_success = 0

signal minigame_finished
signal spawn_frisky

func _ready() -> void:
	cursor = $MiniJeu/Cursor
	success_zone = $MiniJeu/SuccessZone
	mini_jeu = $MiniJeu
	
func _process(delta: float) -> void:
	# Déplacer le curseur
	move_cursor(delta)

	# Vérifier si l'utilisateur appuie sur "espace"
	if Input.is_action_just_pressed("ui_accept"):
		if is_playing:
			check_success()

func set_difficulty(diff: int) -> void:
	cursor = $MiniJeu/Cursor
	success_zone = $MiniJeu/SuccessZone
	mini_jeu = $MiniJeu
	mini_jeu.visible = false
	
	nb_success_required = diff
	
	if (diff == 1):
		success_zone.scale.x = 0.40
		CURSOR_SPEED = 1.0
	elif (diff == 2):
		success_zone.scale.x = 0.25
		CURSOR_SPEED = 1.2
	elif (diff == 3):
		success_zone.scale.x = 0.20
		CURSOR_SPEED = 1.4

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
		nb_success += 1
		if (nb_success == nb_success_required):
			trigger_finish()
			queue_free()
		print('BRAVO !')
	else:
		print('NUL !')

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == cursor:
		cursor_valid = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() == cursor:
		cursor_valid = false
		

func activate_minigame() -> void:
	is_playing = true
	mini_jeu.visible = true
	
func trigger_finish() -> void:
	emit_signal("minigame_finished")
	spawn_friskies()

func spawn_friskies() -> void:
	var spread_distance = 150
	var nb_friskies = randi_range(2, 4)
	for i in range(nb_friskies):
		var frisk_pos = Vector2(position.x + randi_range(-spread_distance, spread_distance), position.y + randi_range(-spread_distance, spread_distance))
		emit_signal("spawn_frisky", frisk_pos)
