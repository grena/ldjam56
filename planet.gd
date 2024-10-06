extends Node2D

const radius_max_tree_generation = 1500
const radius_min_tree_generation = 500
const tree_count = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$IntroPlayer.play()

	_generate_friskies()
	_generate_trees()
	
	# reduce volume
	$MusicPlayerStep1.volume_db = -10
	$MusicPlayerStep2.volume_db = -10
	$MusicPlayerStep3.volume_db = -10

func _generate_friskies() -> void:
	return
	var nb_friskies = 20
	for i in range(nb_friskies):
		spawn_frisky(Vector2(randi() % 1000, randi() % 1000))
		
func _generate_trees() -> void:
	var tree_model = preload("res://tree.tscn")
	for i in range(tree_count):
		var new_tree: FriskyTree = tree_model.instantiate()
		var position = _get_new_tree_position();
		new_tree.position = position
		new_tree.set_z_index(new_tree.global_position.y / 10 + 2000)
		new_tree.visible = true
		new_tree.set_difficulty(randi_range(1, 3))
			# Connecter le signal 'minigame_finished' à une méthode dans ce script
		new_tree.connect("minigame_finished", Callable(self, "_on_minigame_finished"))
		new_tree.connect("minigame_started", Callable(self, "_on_minigame_started"))
		new_tree.connect("spawn_frisky", Callable(self, "_on_spawn_frisky"))
		
		self.add_child(new_tree)
		
func _on_minigame_finished():
	$Player.exit_minigame()
	
func _on_minigame_started():
	$Player.enter_minigame()
			
func _on_spawn_frisky(pos):
	print_debug('ON SPOWN DU FRISKY')
	spawn_frisky(pos)

func _get_level() -> int:
	if $Player.FUEL > 10:
		return 3
	elif $Player.FUEL > 5:
		return 2
	else:
		return 1

func _process(delta):
	find_child('Fusee').set_z_index(find_child('Fusee').global_position.y / 10 + 2000)
	var level = _get_level()
	if level == 2 and $MusicPlayerStep2.playing == false:
		$MusicPlayerStep1.stop()
		$MusicPlayerStep2.play()
		$MusicPlayerStep3.stop()
	elif level == 3 and $MusicPlayerStep3.playing == false:
		$MusicPlayerStep1.stop()
		$MusicPlayerStep2.stop()
		$MusicPlayerStep3.play()
	elif level == 1 and $MusicPlayerStep1.playing == false:
		$MusicPlayerStep1.play()
		$MusicPlayerStep2.stop()
		$MusicPlayerStep3.stop()

func spawn_frisky(pos) -> void:
	var frisky_model = preload("res://frisky.tscn")
	var new_frisky = frisky_model.instantiate()
	new_frisky.position.x = pos.x
	new_frisky.position.y = pos.y
	new_frisky.visible = true
	self.add_child(new_frisky)

func _get_new_tree_position():
	var remaining_tests = 100
	
	while remaining_tests >= 0:
		var radius = randf_range(radius_min_tree_generation, radius_max_tree_generation)
		var angle = randf_range(0, 2*PI)
		var position = Vector2(
			sin(angle) * radius,
			cos(angle) * radius
		)
		if !_is_too_close_from_existing_tree(position):
			return position
	
	return position

func _is_too_close_from_existing_tree(position: Vector2):
	for child in get_children():
		if child is FriskyTree:
			var other_tree_position = child.position
			var distance_to_position = other_tree_position.distance_to(position)
			if distance_to_position <= 200:
				return true
	return false
				
