extends CanvasLayer

const MAX_FUEL = 200.0  # Le maximum de carburant correspondant à 100%

# Référence au QuadMesh qui représente la jauge de fuel
@onready var niveau_fuel = $JaugeFuel #$Jauge.find_child('NiveauFuel')
@onready var position_origin = niveau_fuel.position.y

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("IntroGameRect").visible = false
	pass

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
