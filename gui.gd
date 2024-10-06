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
	# affiche panneau
	get_node("IntroGameRect").visible = false
	get_parent().get_node("MusicPlayerStep1").play()
	get_node("TalkPanelRect").visible = true
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
		$TalkPanelRect/JackDitOkPlayer.play()
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();
	# ferme le panneau
	#my_wait_time = my_wait_time + 1
	#var timer2: Timer = Timer.new()
	#timer2.wait_time = my_wait_time;
	#timer2.one_shot = true;
	#timer2.connect('timeout', func ():
		#get_node("TalkPanelRect").visible = false
		#timer2.stop();
		#timer2.queue_free();
	#);
	#add_child(timer2);
	#timer2.start();
