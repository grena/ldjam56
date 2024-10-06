extends CanvasLayer

const MAX_FUEL = 200.0  # Le maximum de carburant correspondant à 100%

var IS_GAME_STARTED = false

# Référence au QuadMesh qui représente la jauge de fuel
@onready var niveau_fuel = $JaugeFuel #$Jauge.find_child('NiveauFuel')
@onready var position_origin = niveau_fuel.position.y

var fusee : CPUParticles2D
var etoiles : CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("IntroGameRect").visible = false
	fusee = $CPUParticles2DFusee
	etoiles = $CPUParticles2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_node('Player')
	#clamp(player.FUEL, 0, MAX_FUEL)  # S'assurer que la valeur de fuel est entre 0 et 200
	var fuel_percentage = player.FUEL / MAX_FUEL # 200 fuel = 100% donc on calcule le pourcentage
	# Appliquer la mise à jour de la taille (échelle) de la jauge en fonction de fuel_percentage
	# On suppose ici que la hauteur de la jauge est liée à son échelle sur l'axe Y
	#niveau_fuel.scale.y = fuel_percentage  # Ajuster l'échelle Y en fonction du pourcentage
	#print('coucou', niveau_fuel.scale.y)
	niveau_fuel.size.y = fuel_percentage * 100   # Ajuster l'échelle Y en fonction du pourcentage
	niveau_fuel.position.y = position_origin - fuel_percentage * 100
	
	if Input.is_action_just_pressed("ui_accept") and !IS_GAME_STARTED:
		start_game()

func stop_introduction():
	fusee.emitting = false
	etoiles.emitting = false
	etoiles.visible = false
	get_node("IntroGameRect").visible = false
	get_parent().get_node("MusicPlayerStep1").play()
	IS_GAME_STARTED = true

func start_game():
	get_node("StartGameRect/IntroPlayer").play()
	$StartGameRect/MenuPlayer.stop()
	get_node("IntroGameRect").visible = true
	get_node("StartGameRect").visible = false

	var my_wait_time = 8
	var toussoteTimer: Timer = Timer.new()
	toussoteTimer.wait_time = 3;
	toussoteTimer.one_shot = true;
	toussoteTimer.connect('timeout', func ():
		fusee.toussoter()
		toussoteTimer.stop()
		toussoteTimer.queue_free()
	);
	add_child(toussoteTimer);
	toussoteTimer.start()
	
	var crashTimer: Timer = Timer.new()
	crashTimer.wait_time = 4.5;
	crashTimer.one_shot = true;
	crashTimer.connect('timeout', func ():
		fusee.crash()
		crashTimer.stop()
		crashTimer.queue_free()
	);
	add_child(crashTimer);
	crashTimer.start()

	var timer: Timer = Timer.new()
	timer.wait_time = my_wait_time + 5;
	timer.one_shot = true;
	timer.connect('timeout', func ():
		stop_introduction()
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();
