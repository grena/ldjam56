extends CharacterBody2D

const SPEED = 300.0
var FUEL = 0

func _ready() -> void:
	# Activer cette caméra à la démarrage
	$Camera2D.make_current()

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO
	
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
	
	# Déplacement du personnage et détection de collision
	var collision = move_and_collide(velocity * delta)
	
	# Si une collision est détectée
	if collision:
		check_collision_with_frisky(collision)

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
		update_fuel_label(FUEL)

func update_fuel_label(fuel_value: int) -> void:
	# Accéder au Label à partir de la nouvelle hiérarchie
	var label = $Camera2D/UI/Label
	label.text = "FUEL = " + str(fuel_value)
