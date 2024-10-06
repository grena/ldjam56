extends Node2D

const radius_max_tree_generation = 1500
const radius_min_tree_generation = 500
const radius_max_frisky_generation = 500
const radius_min_frisky_generation = 200

const radius_max_static_tree_generation = 2500
const radius_min_static_tree_generation = 1700

const tree_count = 50
const nb_static_trees = 200
const bush_count = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	_generate_friskies()
	_generate_trees()
	_generate_static_trees()
	_generate_buissons()
	
	# reduce volume
	$MusicPlayerStep1.volume_db = -10
	$MusicPlayerStep2.volume_db = -10
	$MusicPlayerStep3.volume_db = -10

func _generate_friskies() -> void:
	var nb_friskies = 20
	for i in range(nb_friskies):
		var pos = _get_new_frisky_position()
		spawn_frisky(pos)
		
func _generate_static_trees() -> void:
	for i in range(nb_static_trees):
		var pos = _get_new_static_tree_position()
		spawn_static_tree(pos)

func _generate_trees() -> void:
	var tree_model = preload("res://tree.tscn")
	for i in range(tree_count):
		var new_tree: FriskyTree = tree_model.instantiate()
		var position = _get_new_tree_position();
		new_tree.position = position
		new_tree.set_z_index(new_tree.global_position.y / 10 + 2000 + 5)
		new_tree.visible = true
		new_tree.set_difficulty(randi_range(1, 3))
			# Connecter le signal 'minigame_finished' à une méthode dans ce script
		new_tree.connect("minigame_finished", Callable(self, "_on_minigame_finished"))
		new_tree.connect("minigame_started", Callable(self, "_on_minigame_started"))
		new_tree.connect("spawn_frisky", Callable(self, "_on_spawn_frisky"))
		
		self.add_child(new_tree)

func _generate_buissons() -> void:
	var bush_model = preload("res://buisson.tscn")
	for i in range(bush_count):
		var new_bush = bush_model.instantiate()
		var position = _get_new_tree_position();
		new_bush.position = position
		new_bush.set_z_index(new_bush.global_position.y / 10 + 2000 - 10)
		new_bush.visible = true
		
		self.add_child(new_bush)
		
func _on_minigame_finished():
	$Player.exit_minigame()
	
func _on_minigame_started():
	$Player.enter_minigame()
			
func _on_spawn_frisky(pos):
	print_debug('ON SPOWN DU FRISKY')
	spawn_frisky(pos)

func _get_level() -> int:
	if $Player.FUEL >= get_node("GUI").MAX_FUEL:
		return 4
	elif $Player.FUEL >= 50:
		return 3
	elif $Player.FUEL >= 15:
		return 2
	else:
		return 1

func _process(delta):
	find_child('Fusee').set_z_index(find_child('Fusee').global_position.y / 10 + 2000)

func spawn_frisky(pos) -> void:
	var frisky_model = preload("res://frisky.tscn")
	var new_frisky = frisky_model.instantiate()
	new_frisky.position.x = pos.x
	new_frisky.position.y = pos.y
	new_frisky.visible = true
	#new_frisky.set_z_index(new_frisky.global_position.y / 10 + 2000 + 5)
	self.add_child(new_frisky)
	
func spawn_static_tree(pos) -> void:
	var frisky_model = preload("res://simple_tree.tscn")
	var new_frisky = frisky_model.instantiate()
	new_frisky.position.x = pos.x
	new_frisky.position.y = pos.y
	new_frisky.visible = true
	new_frisky.set_z_index(new_frisky.global_position.y / 10 + 2000 + 5)
	self.add_child(new_frisky)

func _get_new_frisky_position():
	var remaining_tests = 100
	
	while remaining_tests >= 0:
		var radius = randf_range(radius_min_frisky_generation, radius_max_frisky_generation)
		var angle = randf_range(0, 2*PI)
		var position = Vector2(
			sin(angle) * radius,
			cos(angle) * radius
		)
		if !_is_too_close_from_existing_tree(position):
			return position
	
	return position
	
func _get_new_static_tree_position():
	var remaining_tests = 100	
	
	while remaining_tests >= 0:
		var radius = randf_range(radius_min_static_tree_generation, radius_max_static_tree_generation)
		var angle = randf_range(0, 2*PI)
		var position = Vector2(
			sin(angle) * radius,
			cos(angle) * radius
		)
		if !_is_too_close_from_existing_static_tree(position):
				return position
	
	return position

	
	return position

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
	
func _is_too_close_from_existing_static_tree(position: Vector2):
	for child in get_children():
		if child is SimpleTree:
			var other_tree_position = child.position
			var distance_to_position = other_tree_position.distance_to(position)
			if distance_to_position <= 200:
				return true
	return false
				
				
func update_ramassed_fuel(fuel):
	const max_fuel = 80
	const max_glow = 2.0
	$WorldEnvironment.environment.glow_intensity = max_glow - float(fuel) * max_glow / max_fuel
	const max_modulate = 0.7
	const max_color = 1.0
	var modulate: float = max_color - float(fuel) * (max_color - max_modulate) / max_fuel
	$Floor.modulate = Color(modulate, modulate, modulate, 1.0);
