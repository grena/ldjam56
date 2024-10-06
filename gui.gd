extends CanvasLayer

const MAX_FUEL = 200.0  # Le maximum de carburant correspondant à 100%
var IS_GAME_STARTED = false

# Référence au QuadMesh qui représente la jauge de fuel

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
	var fuel_percentage = player.FUEL / MAX_FUEL # 200 fuel = 100% donc on calcule le pourcentage
	
	if Input.is_action_just_pressed("ui_accept") and !IS_GAME_STARTED:
		start_game()

	if fuel_percentage > 1:
		fuel_percentage = 1
	$TextureRect.set_remplissage(fuel_percentage)

	# fermer la fenetre
	if Input.is_action_pressed("ui_accept"):
		var panel_talk = get_node("TalkPanelRect")
		if panel_talk.visible == true:
			panel_talk.visible = false


func stop_introduction():
	fusee.emitting = false
	etoiles.emitting = false
	etoiles.visible = false
	get_node("IntroGameRect").visible = false
	demarre_sur_planete()
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
	
	var crashingTimer: Timer = Timer.new()
	crashingTimer.wait_time = 13;
	crashingTimer.one_shot = true;
	crashingTimer.connect('timeout', func ():
		stop_introduction()
		crashingTimer.stop()
		crashingTimer.queue_free()
		
	);
	add_child(crashingTimer);
	crashingTimer.start()
	
	
func demarre_sur_planete():
	# affiche panneau
	get_node("IntroGameRect").visible = false
	get_parent().get_node("MusicPlayerStep1").play()
	get_node("TalkPanelRect").visible = true
	get_node("TalkPanelRect/HBoxContainer/JackRect").visible = false
	# affiche textes
	var texts = [
		"\nJacques, we don't have any more fuel.\n",
		"You can refill using purple stuff with your aspirator\n",
		"Take care, legend tells huge creatures are around...\n",
		"(Press space to close)"
	]
	var cortana_voix = [
		$TalkPanelRect/CortanaPlayer1,
		$TalkPanelRect/CortanaPlayer2,
		$TalkPanelRect/CortanaPlayer3,
		$TalkPanelRect/CortanaPlayer4,
		$TalkPanelRect/CortanaPlayer5,
	]
	var my_wait_time = 1
	var voix_index = 0
	for text in texts:
		var timer: Timer = Timer.new()
		timer.wait_time = my_wait_time;
		timer.one_shot = true;
		timer.connect('timeout', func ():
			get_node("TalkPanelRect/HBoxContainer/Text").text = get_node("TalkPanelRect/HBoxContainer/Text").text + text
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
		get_node("TalkPanelRect/HBoxContainer/JackRect").visible = true
		$TalkPanelRect/JackDitOkPlayer.play()
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();
