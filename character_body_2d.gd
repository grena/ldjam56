extends CharacterBody2D

const SPEED = 300.0
var FUEL = 0

const SQUISH_AMOUNT = 0.15  # Le facteur de squish (1.0 = normal, <1.0 = compression)
const SQUISH_TIME = 0.2    # Temps pour animer le squish
const ROTATION_AMOUNT = 0.2

var original_scale = Vector2(1, 1)
var squish_timer = 0.0
var last_direction = 1  # 1 = droite, -1 = gauche
var is_playing_mini_game = false

func _ready() -> void:
	# Activer cette caméra à la démarrage
	$Camera2D.make_current()
	original_scale = $Sprite2D.scale
	

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
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

# Fonction dédiée à la reconnaissance de collision
func check_collision_with_frisky(collision) -> void:
	var collider = collision.get_collider()
	var collider_parent = collider.get_parent()

	# Vérification si le parent est de type "Frisky"
	if collider_parent is Frisky:
		FUEL = FUEL + 1
		print("Collision with a Frisky!")
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
		is_playing_mini_game = true
		collider_parent.activate_minigame()
		#print("Collision with a Tree!")
		# On détruit la Frisky
		#collider_parent.queue_free()

func update_fuel_label(fuel_value: int) -> void:
	# Accéder au Label à partir de la nouvelle hiérarchie
	var label = get_node("/root/Node2D/CanvasLayer/Label")
	label.text = "FUEL = " + str(fuel_value)

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
