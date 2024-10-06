extends CanvasLayer

const MAX_FUEL = 200.0  # Le maximum de carburant correspondant à 100%

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("IntroGameRect").visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player = get_parent().get_node('Player')
	var fuel_percentage = player.FUEL / MAX_FUEL # 200 fuel = 100% donc on calcule le pourcentage
	if fuel_percentage > 1:
		fuel_percentage = 1
	$TextureRect.set_remplissage(fuel_percentage)

	# fermer la fenetre
	if Input.is_action_pressed("ui_accept"):
		var panel_talk = get_node("TalkPanelRect")
		if panel_talk.visible == true:
			panel_talk.visible = false

func _on_button_pressed_start_game() -> void:
	#get_node("StartGameRect/IntroPlayer").play()
	get_node("IntroGameRect").visible = true
	get_node("StartGameRect").visible = false
	## affiche les textes un par un
	#var texts = [
		#get_node("IntroGameRect/GridContainer/Texte1"),
		#get_node("IntroGameRect/GridContainer/Texte2"),
		#get_node("IntroGameRect/GridContainer/Texte3"),
		#get_node("IntroGameRect/GridContainer/Texte4"),
	#]
	#var my_wait_time = 3
	#for text in texts:
		#var timer: Timer = Timer.new()
		#timer.wait_time = my_wait_time;
		#timer.one_shot = true;
		#timer.connect('timeout', func ():
			#text.visible = true
			#timer.stop();
			#timer.queue_free();
		#);
		#add_child(timer);
		#timer.start();
		#my_wait_time = my_wait_time + 3
	## ferme la fenetre
	#var timer: Timer = Timer.new()
	#timer.wait_time = my_wait_time + 5;
	#timer.one_shot = true;
	#timer.connect('timeout', func ():
		#demarre_sur_planete()
		#timer.stop();
		#timer.queue_free();
	#);
	#add_child(timer);
	#timer.start();
	
	demarre_sur_planete()
	
func demarre_sur_planete():
	get_parent().get_node("MusicPlayerStep1").play()
	var texts = [
		"\nLanded in emergency.\n",
		"No more fuel.\n",
		"Refill with the vacuum.\n",
		"(press space to close)"
	]
	affiche_dialogue(texts)

func passage_niveau_deux():
	get_parent().get_node("UpgradeLevelPlayer").play()
	get_node("TextureRect").set_sound_on()
	get_parent().get_node("MusicPlayerStep1").stop()
	get_parent().get_node("MusicPlayerStep2").play()
	var texts = [
		"\nFuel level 1 reached.\n",
		"Chain saw enabled.\n",
		"Sound in degraded mode.\n",
		"(Press space to close)"
	]
	affiche_dialogue(texts)

func affiche_dialogue(texts): 
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
