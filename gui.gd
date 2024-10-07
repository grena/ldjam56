extends CanvasLayer

@onready var Outro = preload("res://outro.tscn")
@onready var TalkPanel: TalkPanelRect = $TalkPanelRect;

const MAX_FUEL = 80.0  # Le maximum de carburant correspondant à 100%
var IS_GAME_STARTED = false
var IS_DIALOG_OPENED = false
var IS_INTRO_LAUNCHED = false
var IS_DECOLLING = false
var ARRIVED_ON_PLANET = false
var LEVEL2_UPGRADED = false
var LEVEL3_UPGRADED = false
var LEVEL4_UPGRADED = false

# Référence au QuadMesh qui représente la jauge de fuel

var fusee : CPUParticles2D
var etoiles : CPUParticles2D

# position toyo origine pour eviter le declage avec les shake successifs
var toyo_position_origin

#Timers
var toussoteTimer: Timer
var crashTimer: Timer
var crashingTimer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("IntroGameRect").visible = false
	fusee = $CPUParticles2DFusee
	etoiles = $CPUParticles2D
	toyo_position_origin = get_node("TextureRect/Node2D/Toyo").position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_node('Player')
	var fuel_percentage = player.FUEL / MAX_FUEL # 200 fuel = 100% donc on calcule le pourcentage
	
	if Input.is_action_just_pressed("ui_accept") and !IS_GAME_STARTED:
		start_game()

	if fuel_percentage > 1:
		fuel_percentage = 1
	$TextureRect.set_remplissage(fuel_percentage)

 	#skip l'intro
	if Input.is_action_pressed("ui_cancel") and IS_INTRO_LAUNCHED and !IS_GAME_STARTED  :
		stop_introduction()
		
	# fermer la fenetre
	if Input.is_action_pressed("ui_accept") and IS_DIALOG_OPENED:
		if TalkPanel.visible == true:
			if TalkPanel.is_saying_something():
				TalkPanel.finish_the_line()
			else:
				TalkPanel.visible = false
				IS_DIALOG_OPENED = false

func stop_introduction():
	if toussoteTimer != null:
		toussoteTimer.stop()
		toussoteTimer.queue_free()
	if crashTimer != null:
		crashTimer.stop()
		crashTimer.queue_free()
	if crashingTimer != null:
		crashingTimer.stop()
		crashingTimer.queue_free()
		
	get_node("StartGameRect/IntroPlayer").stop()
	fusee.emitting = false
	fusee.visible = false
	etoiles.emitting = false
	etoiles.visible = false
	get_node("IntroGameRect").visible = false
	demarre_sur_planete()
	IS_GAME_STARTED = true

func start_game():
	IS_INTRO_LAUNCHED = true
	get_node("StartGameRect/IntroPlayer").play()
	$StartGameRect/MenuPlayer.stop()
	get_node("IntroGameRect").visible = true
	get_node("StartGameRect").visible = false

	var my_wait_time = 8
	toussoteTimer = Timer.new()
	toussoteTimer.wait_time = 3;
	toussoteTimer.one_shot = true;
	toussoteTimer.connect('timeout', func ():
		fusee.toussoter()
		if toussoteTimer != null:
			toussoteTimer.stop()
			toussoteTimer.queue_free()
	);
	add_child(toussoteTimer);
	toussoteTimer.start()
	
	crashTimer = Timer.new()
	crashTimer.wait_time = 4.5;
	crashTimer.one_shot = true;
	crashTimer.connect('timeout', func ():
		fusee.crash()
		if crashTimer != null:
			crashTimer.stop()
			crashTimer.queue_free()
	);
	add_child(crashTimer);
	crashTimer.start()
	
	crashingTimer = Timer.new()
	crashingTimer.wait_time = 13;
	crashingTimer.one_shot = true;
	crashingTimer.connect('timeout', func ():
		stop_introduction()
		if crashingTimer != null:
			crashingTimer.stop()
			crashingTimer.queue_free()
		
	);
	add_child(crashingTimer);
	crashingTimer.start()

func demarre_sur_planete():
	if ARRIVED_ON_PLANET == false:
		ARRIVED_ON_PLANET = true
		get_parent().get_node('Player/AspibroyeurPlayer').play()
		get_parent().get_node("MusicPlayerStep1").play()
		var texts = [
			"\nLanded in emergency.\n",
			"No more fuel.\n",
			"Refill with the *vacuum+.\n",
			"(press space to close)"
		]
		affiche_dialogue(texts)

func passage_niveau_deux():
	if LEVEL2_UPGRADED == false:
		LEVEL2_UPGRADED = true
		get_parent().get_node("Player").get_node("BruitDePasPlayer").stop()
		get_parent().get_node("MusicPlayerStep1").stop()
		get_parent().get_node("MusicPlayerStep2").play()
		get_parent().get_node("UpgradeLevelPlayer").play()
		get_node("TextureRect").set_sound_on()
		get_node("TextureRect").set_xray_on()	
		var texts = [
			"\nFuel level 1 reached.\n",
			"Turning on basic features.\n",
			"*Chain saw+ enabled.\n",
			"(Press space to close)"
		]
		affiche_dialogue(texts)
		shake_cabine_when_upgrade()

func passage_niveau_trois():
	if LEVEL3_UPGRADED == false:
		LEVEL3_UPGRADED = true
		get_parent().get_node("Player").get_node("BruitDePasPlayer").stop()
		get_parent().get_node("MusicPlayerStep2").stop()
		get_parent().get_node("MusicPlayerStep3").play()
		get_parent().get_node("UpgradeLevelPlayer").play()
		get_node("TextureRect").set_translator_on()
		get_node("TextureRect").set_display_blobs_in_xray()  
		var texts = [
			"\nFuel level 2 reached.\n",
			"Turning on advanced features.\n",
			"*Flame thrower+ enabled.\n",
			"(Press space to close)"
		]
		affiche_dialogue(texts)
		shake_cabine_when_upgrade()

func le_vaisseau_est_pret():
	if LEVEL4_UPGRADED == false:
		LEVEL4_UPGRADED = true
		get_parent().get_node("Player").get_node("BruitDePasPlayer").stop()
		get_parent().get_node("UpgradeLevelPlayer").play()
		get_node("TextureRect").set_translator_on()
		get_node("TextureRect").set_display_blobs_in_xray()  
		var texts = [
			"\nEnough fuel to leave.\n",
			"*Go back to the ship.+\n",
			"(Press space to close)"
		]
		affiche_dialogue(texts)
		shake_cabine_when_upgrade()

func affiche_dialogue(texts):
	IS_DIALOG_OPENED = true
	# affiche panneau
	get_node("IntroGameRect").visible = false
	get_node("TalkPanelRect").visible = true
	TalkPanel.affiche_dialog(texts)

func shake_cabine_when_upgrade():
	var timer: Timer = Timer.new()
	timer.wait_time = 6;
	timer.one_shot = true;
	timer.connect('timeout', func ():
		# shake shake shake
		var cabine_fusee = get_node("TextureRect/Node2D")
		var tween = create_tween()
		for shake in range(0, 50):
			tween.tween_property(
				cabine_fusee,
				"position",
				cabine_fusee.position - Vector2(randi_range(2, 8), 0),
				0.05
			)
			tween.tween_property(
				cabine_fusee,
				"position",
				cabine_fusee.position - Vector2(randi_range(-8, -2), 0),
				0.05
			)
		# end shake shake shake
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();

func shake_toyo_when_aspire():
	var timer: Timer = Timer.new()
	timer.wait_time = 0.1;
	timer.one_shot = true;
	timer.connect('timeout', func ():
		# shake shake shake
		var toyo = get_node("TextureRect/Node2D/Toyo")
		var tween = create_tween()
		for shake in range(0, 6):
			tween.tween_property(
				toyo,
				"position",
				toyo_position_origin - Vector2(randi_range(5, 15), randi_range(5, 15)),
				0.05
			)
			tween.tween_property(
				toyo,
				"position",
				toyo_position_origin - Vector2(randi_range(-15, -5), randi_range(-15, -5)),
				0.05
			)
		# end shake shake shake
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();

func decolle_batard():
	if IS_DECOLLING == false:
		IS_DECOLLING = true
		
		var outro = Outro.instantiate()
		get_parent().add_child(outro)
		outro.launch_outro()


func has_cut_tree():
	$TextureRect.has_cut_tree();
