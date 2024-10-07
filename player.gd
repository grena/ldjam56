extends CharacterBody2D

const SPEED = 300.0
var FUEL = 0

const SQUISH_AMOUNT = 0.15  # Le facteur de squish (1.0 = normal, <1.0 = compression)
const SQUISH_TIME = 0.2    # Temps pour animer le squish
const ROTATION_AMOUNT = 0.15
const MAX_RADIUS = 1500

var original_scale = Vector2(1, 1)
var squish_timer = 0.0
var last_direction = 1  # 1 = droite, -1 = gauche
var is_playing_mini_game = false

var particles_loot : GPUParticles2D

func _ready() -> void:
	# Activer cette caméra à la démarrage
	$Camera2D.make_current()
	original_scale = $Sprite2D.scale
	particles_loot = $GPUParticles2D

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if (!get_parent().get_node('GUI').IS_GAME_STARTED):
		return
	
	if (get_parent().get_node('GUI').IS_DIALOG_OPENED):
		return

	if (get_parent().get_node('GUI').IS_DECOLLING):
		return
	
	if (is_playing_mini_game):
		return
	
	# Gestion des déplacements avec ZQSD
	if Input.is_action_pressed("ui_up"):
		velocity.y -= SPEED
	if Input.is_action_pressed("ui_down"):
		velocity.y += SPEED
	if Input.is_action_pressed("ui_left"):
		velocity.x -= SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += SPEED
	
	# Bruit de pas
	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		if $BruitDePasPlayer.playing == false:
			$BruitDePasPlayer.play()
	else:
		$BruitDePasPlayer.stop()

	# Appliquer le mouvement
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		
	# Déplacement du personnage
	move_and_collide(velocity * delta)
	
	# Si le personnage se déplace, appliquer l'effet de squish
	if velocity.length() > 0:
		apply_squish_effect(delta)
		handle_sprite_flip(velocity)
		apply_rotation_effect(velocity)
	else:
		# Rétablir l'échelle originale quand le personnage ne bouge pas
		reset_squish_effect(delta)
		reset_rotation_effect(delta)
	
	# Déplacement du personnage et détection de collision
	var collision = move_and_collide(velocity * delta)
	
	# Si une collision est détectée
	if collision:
		check_collision_with_frisky(collision)
		check_collision_with_tree(collision)

	self.set_z_index(self.global_position.y / 10 + 2000)
	
	var distance_to_center = self.global_position.distance_to(Vector2(0, 0))
	if distance_to_center > MAX_RADIUS:
		var new_position = self.global_position.normalized() * MAX_RADIUS
		self.global_position = new_position

# Fonction dédiée à la reconnaissance de collision
func check_collision_with_frisky(collision) -> void:
	var collider = collision.get_collider()
	var collider_parent = collider.get_parent()

	# Vérification si le parent est de type "Frisky"
	if collider_parent is Frisky:
		particles_loot.emitting = true
		# detecter l'upgrade de level
		var level_precedent = get_parent()._get_level()
		FUEL = FUEL + 1
		var level_actuel = get_parent()._get_level()
		get_parent().update_ramassed_fuel(FUEL)
		# passage niveau 2
		if level_actuel > level_precedent:
			if level_actuel == 2:
				get_parent().get_node("GUI").passage_niveau_deux()
			elif level_actuel == 3:
				get_parent().get_node("GUI").passage_niveau_trois()
			elif level_actuel == 4:
				get_parent().get_node("GUI").le_vaisseau_est_pret()
		# ramassage de frisky
		var bruits_aspiro = [$AspirePetitPlayer, $AspireGrosPlayer]
		bruits_aspiro.pick_random().play()
		# vibrage de toyo
		get_parent().get_node("GUI").shake_toyo_when_aspire()
		get_parent().get_node("GUI").flash_toyo()

		# On détruit la Frisky
		collider_parent.queue_free()
		self.get_parent().find_child('Tubes').avale();
		update_fuel_label(FUEL)
		

# Fonction dédiée à la reconnaissance de collision
func check_collision_with_tree(collision) -> void:
	var collider = collision.get_collider()
	var collider_parent = collider.get_parent()

	# Vérification si le parent est de type "Frisky"
	if collider_parent is FriskyTree:
		return
		is_playing_mini_game = true
		collider_parent.activate_minigame()
		#print("Collision with a Tree!")
		# On détruit la Frisky
		#collider_parent.queue_free()
	
func update_fuel_label(fuel_value: int) -> void:
	# Accéder au Label à partir de la nouvelle hiérarchie
	var label = get_parent().get_node("GUI").get_node("Label")
	label.text = "FUEL = " + str(fuel_value)
	print_debug("fuel = "+str(fuel_value))

func apply_squish_effect(delta: float) -> void:
	squish_timer += delta
	
	# Compression sur l'axe Y et étirement sur l'axe X
	var new_scale = original_scale
	new_scale.y = lerp(original_scale.y, SQUISH_AMOUNT, squish_timer / SQUISH_TIME)
	new_scale.x = lerp(original_scale.x, 1 / SQUISH_AMOUNT, squish_timer / SQUISH_TIME)
	
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

# Fonction pour gérer le flip horizontal du Sprite2D
func handle_sprite_flip(velocity: Vector2) -> void:
	var sprite = $Sprite2D
	
	# Détection de la direction du personnage
	if velocity.x < 0:  # Si le personnage va vers la gauche
		sprite.scale.x = -original_scale.x  # Inverser l'axe X
		last_direction = -1  # Stocker la dernière direction (gauche)
	elif velocity.x > 0:  # Si le personnage va vers la droite
		sprite.scale.x = original_scale.x  # Restaurer l'axe X à sa valeur d'origine
		last_direction = 1  # Stocker la dernière direction (droite)
	
	# Si le personnage est immobile, conserver la dernière direction
	if velocity.x == 0:
		sprite.scale.x = original_scale.x * -last_direction

# Fonction pour appliquer la rotation légère pendant le déplacement
func apply_rotation_effect(velocity: Vector2) -> void:
	var sprite = $Sprite2D
	
	# Appliquer une légère rotation basée sur la direction horizontale
	if velocity.x != 0:
		sprite.rotation = lerp(sprite.rotation, ROTATION_AMOUNT * float(last_direction), 0.1)


# Fonction pour rétablir la rotation lorsque le personnage s'arrête
func reset_rotation_effect(delta: float) -> void:
	var sprite = $Sprite2D
	
	# Réduire la rotation progressivement vers 0 (neutre)
	sprite.rotation = lerp(sprite.rotation, float(0), 0.1)

func exit_minigame() -> void:
	is_playing_mini_game = false

func enter_minigame() -> void:
	is_playing_mini_game = true

func _process(delta: float) -> void:
	$Camera2D.offset.x = 250
