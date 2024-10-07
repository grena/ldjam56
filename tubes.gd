extends Node2D

@onready var TubeScene = preload("res://tube.tscn")

var tubes: Array = [];
const tube_length = 60;
const max_length = 1500
const duration_to_arrive_to_fusee_in_seconds = 1.0
const tubes_count = max_length/tube_length + 2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tubes = [];
	var previous = self;
	for x in range(0, tubes_count):
		var tube: Node2D = TubeScene.instantiate();
		tube.set_duration_of_avale_per_tube(duration_to_arrive_to_fusee_in_seconds / tubes_count);
		tube.position = Vector2(tube_length, 0);
		tubes.append(tube)
		tube.rotation = 0.2 + randf_range(-0.2, 0.2);
		previous.add_child(tube);
		previous = tube;
	tubes[tubes.size() - 1].set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var player = self.get_parent().find_child('Player');
	var player_position: Vector2 = player.global_position;
	var distance = _get_distance();
	
	const limit = 2.8
	
	var i = tubes.size() - 1;
	while (distance > tube_length && i >= 0):
		for x in range(i, tubes.size()):
			var ending_position: Vector2 = tubes[i].global_position;
			var angle = ending_position.angle_to_point(player_position);
			var rotation = angle - tubes[x - 1].global_rotation;
			rotation = fposmod(rotation + PI, 2 * PI) - PI;
			#if rotation > limit:
			#	rotation = limit
			#if rotation < -limit:
			#	rotation = -limit
			tubes[x].rotation = rotation;
		distance = _get_distance();
		i = i - 1;
		
	
func _get_distance():
	var player = self.get_parent().find_child('Player');
	var player_position: Vector2 = player.global_position;
	var ending_position: Vector2 = tubes[tubes.size() - 1].global_position;
	
	return ending_position.distance_to(player_position);


func avale():
	const durationn_per_tube = duration_to_arrive_to_fusee_in_seconds / tubes_count;
	for x in range(0, tubes.size()):
		var timer: Timer = Timer.new()
		timer.wait_time = x * durationn_per_tube;
		timer.one_shot = true;
		timer.connect('timeout', func ():
			tubes[tubes.size() - x - 1].run_avale_animation();
			timer.stop();
			timer.queue_free();
		);
		add_child(timer);
		timer.start();
	# cri de la mort
	crie_bestiole()

func crie_bestiole():	
	var crie_level_2 = [$Level2Mort1Player, $Level2Mort2Player, $Level2Mort3Player]
	var crie_level_3 = [$Level3Mort1Player, $Level3Mort2Player, $Level3Mort3Player, $Level3Mort4Player, $Level3Mort4Player, $Level3Mort5Player]
	var level = get_parent()._get_level()
	# juste le broyeur
	if level == 1:
		broyeur_solo()
	else:
		var player = crie_level_2.pick_random()
		if level == 3 or level == 4:
			player = crie_level_3.pick_random()
			push_text_in_translator()
		broyeur_solo(player)

func push_text_in_translator():
	var translations = [
		'"Nooo"', '"Leave me alone!"', '"Not my child"', '"Get out of my house"', '"Stop killing my friends"',
		'"You killed my dad"', "You killed my mom", '"My bro is dead"', '"What the hell"', '"This is a nightmare!"',
		'"Arghhhh"', '"Fuuuu"', '"Dont touch me"', '"It hurts"', '"We re not fuel!"'
	]
	var translator = get_parent().get_node("GUI").get_node('TextureRect/Node2D/RichTextLabel')
	var timer: Timer = Timer.new()
	timer.wait_time = duration_to_arrive_to_fusee_in_seconds;
	timer.one_shot = true;  
	timer.connect('timeout', func ():
		# push text to translator
		translator.text = "[center][color=#22aa22]"+translations.pick_random()+"[/color][/center]"	
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();
 
func broyeur_solo(cri_player = null):
	var my_broyeurs = [$BroyeurPlayer, $BroyeurPlayer2, $BroyeurPlayer3, $BroyeurPlayer4]
	var timer: Timer = Timer.new()
	timer.wait_time = duration_to_arrive_to_fusee_in_seconds;
	timer.one_shot = true;  
	timer.connect('timeout', func ():
		# des cris
		if cri_player:
			cri_player.play();
		# du broyeur
		my_broyeurs.pick_random().play()
		get_parent().get_node("GUI/TextureRect").run_mixer()
		
		timer.stop();
		timer.queue_free();
	);
	add_child(timer);
	timer.start();

	
