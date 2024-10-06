extends CanvasLayer

const MAX_FUEL = 80.0  # Le maximum de carburant correspondant à 100%
var IS_GAME_STARTED = false
var IS_DIALOG_OPENED = false
var IS_INTRO_LAUNCHED = false
var IS_DECOLLING = false

# Référence au QuadMesh qui représente la jauge de fuel

var fusee : CPUParticles2D
var etoiles : CPUParticles2D

#Timers
var toussoteTimer: Timer
var crashTimer: Timer
var crashingTimer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("IntroGameRect").visible = false
	fusee = $CPUParticles2DFusee
	etoiles = $CPUParticles2D

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
		var panel_talk = get_node("TalkPanelRect")
		if panel_talk.visible == true:
			panel_talk.visible = false
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
	get_parent().get_node('Player/AspibroyeurPlayer').play()
	get_parent().get_node("MusicPlayerStep1").play()
	var texts = [
		"[center]\nLanded in emergency.\n[/center]",
		"[center]No more fuel.\n[/center]",
		"[center]Refill with the [color=yellow]vacuum[/color].[/center]\n",
		"[center](press space to close)[/center]"
	]
	affiche_dialogue(texts)

func passage_niveau_deux():
	get_parent().get_node("MusicPlayerStep1").stop()
	get_parent().get_node("MusicPlayerStep2").play()
	get_parent().get_node("UpgradeLevelPlayer").play()
	get_node("TextureRect").set_sound_on()
	get_node("TextureRect").set_xray_on()	
	var texts = [
		"\n[center]Fuel level 1 reached.[/center]\n",
		"[center]Turning on basic features.[/center]\n",
		"[center][color=yellow]Chain saw[/color] enabled.[/center]\n",
		"[center](Press space to close)[/center]"
	]
	affiche_dialogue(texts)

func passage_niveau_trois():
	get_parent().get_node("MusicPlayerStep2").stop()
	get_parent().get_node("MusicPlayerStep3").play()
	get_parent().get_node("UpgradeLevelPlayer").play()
	get_node("TextureRect").set_translator_on()
	get_node("TextureRect").set_display_blobs_in_xray()  
	var texts = [
		"\n[center]Fuel level 2 reached.[/center]\n",
		"[center]Turning on advanced features.[/center]\n",
		"[center][color=yellow]Flame thrower[/color] enabled.[/center]\n",
		"[center](Press space to close)[/center]"
	]
	affiche_dialogue(texts)

func le_vaisseau_est_pret():
	get_parent().get_node("UpgradeLevelPlayer").play()
	get_node("TextureRect").set_translator_on()
	get_node("TextureRect").set_display_blobs_in_xray()  
	var texts = [
		"\n[center]Enough fuel to leave.[/center]\n",
		"[center][color=yellow]Go back to the ship.[/color][/center]\n",
		"[center](Press space to close)[/center]"
	]
	affiche_dialogue(texts)

func affiche_dialogue(texts):
	IS_DIALOG_OPENED = true
	print(IS_DIALOG_OPENED)
	# affiche panneau
	get_node("IntroGameRect").visible = false
	get_node("TalkPanelRect").visible = true
	get_node("TalkPanelRect/JackRect").visible = false
	# affiche textes
	var cortana_voix = [
		$TalkPanelRect/CortanaPlayer1,
		$TalkPanelRect/CortanaPlayer2,
		$TalkPanelRect/CortanaPlayer3,
		$TalkPanelRect/CortanaPlayer4,
		$TalkPanelRect/CortanaPlayer5,
	]
	get_node("TalkPanelRect/Text").text = ""
	var my_wait_time = 1
	var voix_index = 0
	for text in texts:
		var timer: Timer = Timer.new()
		timer.wait_time = my_wait_time;
		timer.one_shot = true;
		timer.connect('timeout', func ():
			get_node("TalkPanelRect/Text").text = get_node("TalkPanelRect/Text").text + text
			cortana_voix[voix_index].play()
			timer.stop();
			timer.queue_free();
		);
		add_child(timer);
		timer.start();
		my_wait_time = my_wait_time + 2
		voix_index = voix_index + 1
	# dis ok

	var timer: Timer = Timer.new()
	timer.wait_time = my_wait_time;
	timer.one_shot = true;
	timer.connect('timeout', func ():
		get_node("TalkPanelRect/JackRect").visible = true
		$TalkPanelRect/JackDitOkPlayer.play()
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();

func decolle_batard():
	IS_DECOLLING = true
	# tout masquer
	get_node("TextureRect").visible = false
	get_parent().get_node("Player").visible = false
	get_parent().get_node("Tubes").visible = false
	get_parent().get_node("Player").get_node("JackDitGoPlayer").play()
	var magrossefuseeturgecente = get_parent().get_node("Fusee")
	# son dcollage
	magrossefuseeturgecente.get_node("DecollagePlayer").play()
	
	var timer: Timer = Timer.new()
	timer.wait_time = 5;
	timer.one_shot = true;
	timer.connect('timeout', func ():

		var tween = create_tween()
		tween.tween_property(
			magrossefuseeturgecente,
			"position",
			magrossefuseeturgecente.position - Vector2(0, 1200),
			3
		)

		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();

	
