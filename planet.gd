extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_generate_friskies()
	_generate_trees()

func _generate_friskies() -> void:
	var frisky_model = preload("res://frisky.tscn")
	var nb_friskies = 20
	for i in range(nb_friskies):
		var new_frisky = frisky_model.instantiate()
		new_frisky.position.x = randi() % 1000
		new_frisky.position.y = randi() % 1000
		new_frisky.visible = true
		self.add_child(new_frisky)
		
func _generate_trees() -> void:
	var tree_model = preload("res://tree.tscn")
	var nb_trees = 4
	for i in range(nb_trees):
		var new_tree = tree_model.instantiate()
		new_tree.position.x = randi() % 1000
		new_tree.position.y = randi() % 1000
		new_tree.visible = true
		new_tree.set_difficulty(randi_range(1, 3))
			# Connecter le signal 'minigame_finished' à une méthode dans ce script
		new_tree.connect("minigame_finished", Callable(self, "_on_minigame_finished"))
		self.add_child(new_tree)
		
func _process(delta):
	if $MusicPlayer.playing == false:
		$MusicPlayer.play()

func _on_minigame_finished():
	print("Le mini-jeu est terminé !")
	$CharacterBody2D.exit_minigame()
	# Exécuter ici toute logique nécessaire
