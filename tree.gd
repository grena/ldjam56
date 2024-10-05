extends Node2D

class_name FriskyTree

# Vitesse du curseur (peut être ajustée)
var CURSOR_SPEED = 500.0
var HEALTH = 3

const SQUISH_AMOUNT = 0.45  # Le facteur de squish (1.0 = normal, <1.0 = compression)
const SQUISH_TIME = 0.150    # Temps pour animer le squish

# Références vers les MeshInstance2D
var minigame : Node2D
var minigame_tronconneuse : Sprite2D
var minigame_treefull : Sprite2D
var minigame_treemid : Sprite2D
var minigame_treelow : Sprite2D
var world_tree_sprite : Sprite2D

var audio_engine : AudioStreamPlayer2D
var audio_decoupe: AudioStreamPlayer2D

var is_playing = false
var moving_right = true
var cursor_valid = false

const duration_to_squish_in_seconds = 0.2
var is_squishing = false
var original_scale = Vector2(1, 1)
var squish_timer = 0.0

var is_waiting_for_player_interaction = false

signal minigame_started
signal minigame_finished
signal spawn_frisky

func _ready() -> void:
	original_scale = $Sprite2D.scale
	minigame_tronconneuse = $MiniGame/Tronconneuse
	minigame_treefull = $MiniGame/TreeFull
	minigame_treemid = $MiniGame/TreeMid
	minigame_treelow = $MiniGame/TreeLow
	audio_engine = $MiniGame/AudioEngine
	audio_decoupe = $MiniGame/AudioDecoupe
	minigame = $MiniGame
	minigame.visible = false
	world_tree_sprite = $Sprite2D
	
func _process(delta: float) -> void:
	# Déplacer la tronconneuse
	if is_playing:
		move_tronconneuse(delta)
		update_tronc(delta)
	
	# Vérifier si l'utilisateur appuie sur "espace"
	if Input.is_action_just_pressed("ui_accept"):
		if is_playing:
			check_success()
		elif is_waiting_for_player_interaction:
			activate_minigame()
			
	if is_squishing:
		apply_squish_effect(delta)
	else:
		reset_squish_effect(delta)
	
func update_tronc(delta: float) -> void:
	if cursor_valid:
		minigame_treefull.modulate = Color(1.3, 1.3, 1.3, 1.0)
		minigame_treemid.modulate = Color(1.3, 1.3, 1.3, 1.0)
		minigame_treelow.modulate = Color(1.3, 1.3, 1.3, 1.0)
	else:
		minigame_treefull.modulate = Color(1.0, 1.0, 1.0, 1.0)
		minigame_treemid.modulate = Color(1.0, 1.0, 1.0, 1.0)
		minigame_treelow.modulate = Color(1.0, 1.0, 1.0, 1.0)
		
	if HEALTH == 2 and !minigame_treemid.visible:
		minigame_treemid.visible = true
		minigame_treefull.visible = false
	if HEALTH == 1 and !minigame_treelow.visible:
		minigame_treelow.visible = true
		minigame_treemid.visible = false
		
		
func set_difficulty(diff: int) -> void:
	if (diff == 1):
		CURSOR_SPEED = 500.0
	elif (diff == 2):
		CURSOR_SPEED = 700.0
	elif (diff == 3):
		CURSOR_SPEED = 900.0

# Fonction pour déplacer le curseur de droite à gauche
func move_tronconneuse(delta: float) -> void:
	var tronconneuse_position = minigame_tronconneuse.position

	# Si le curseur va vers la droite
	if moving_right:
		tronconneuse_position.x += CURSOR_SPEED * delta
		# Si le curseur atteint le bord droit du MiniJeu, changer de direction
		if tronconneuse_position.x >= 248:
			moving_right = false
	# Si le curseur va vers la gauche
	else:
		tronconneuse_position.x -= CURSOR_SPEED * delta
		# Si le curseur atteint le bord gauche du MiniJeu, changer de direction
		if tronconneuse_position.x <= -234:
			moving_right = true
			
	if tronconneuse_position.x > -128 and tronconneuse_position.x < 126:
		cursor_valid = true
	else:
		cursor_valid = false

	# Appliquer la nouvelle position
	minigame_tronconneuse.position = tronconneuse_position

# Fonction pour vérifier si le curseur est dans la zone de succès
func check_success() -> void:
	if cursor_valid:
		squish_tree()
		HEALTH -= 1      
		audio_decoupe.play()
		if (HEALTH == 0):
			trigger_finish()
	else:
		print('NUL !')

func activate_minigame() -> void:
	emit_signal("minigame_started")
	audio_engine.play()
	is_playing = true
	minigame.visible = true
	
func trigger_finish() -> void:
	emit_signal("minigame_finished")
	spawn_friskies()
	is_playing = false
	minigame.visible = false
	
	$Sprite2D.visible = false
	var dead_sprites = [$SpriteDead1, $SpriteDead2, $SpriteDead3]
	dead_sprites[randi_range(0, 2)].visible = true

func spawn_friskies() -> void:
	var spread_distance = 150
	var nb_friskies = randi_range(2, 4)
	for i in range(nb_friskies):
		var frisk_pos = Vector2(position.x + randi_range(-spread_distance, spread_distance), position.y + randi_range(-spread_distance, spread_distance))
		emit_signal("spawn_frisky", frisk_pos)

func apply_squish_effect(delta: float) -> void:
	squish_timer += delta
	
	# Compression sur l'axe Y et étirement sur l'axe X
	var new_scale = original_scale
	new_scale.y = lerp(original_scale.y, SQUISH_AMOUNT, squish_timer / SQUISH_TIME)
	new_scale.x = lerp(original_scale.x, SQUISH_AMOUNT, squish_timer / SQUISH_TIME)
	
	var sprite = $Sprite2D
	sprite.scale = new_scale
	
	if squish_timer >= SQUISH_TIME:
		squish_timer = 0.0  # Réinitialiser le timer pour répéter l'effet

func reset_squish_effect(delta: float) -> void:
	squish_timer += delta
	
	# Revenir à l'échelle normale
	var sprite = $Sprite2D
	var new_scale = sprite.scale
	new_scale = original_scale
	sprite.scale = new_scale
	
	if squish_timer >= SQUISH_TIME:
		squish_timer = 0.0  # Réinitialiser le timer pour le squish suivant
		
func squish_tree() -> void:
	is_squishing = true
	var timer: Timer = Timer.new()
	timer.wait_time = duration_to_squish_in_seconds
	timer.one_shot = true;
	timer.connect('timeout', func ():
		timer.stop();
		timer.queue_free();
		is_squishing = false
	);
	add_child(timer);
	timer.start();

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.name == 'Player'):
		toggle_wait_for_interaction()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body.name == 'Player'):
		toggle_wait_for_interaction()

func toggle_wait_for_interaction():
	is_waiting_for_player_interaction = !is_waiting_for_player_interaction
	
	if (is_waiting_for_player_interaction):
		$Sprite2D.modulate = Color(1.3, 1.3, 1.3, 1.0)  # Rendre le sprite plus clair
		squish_tree()
	else:
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)  # Revenir à la couleur normale
