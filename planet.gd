extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_generate_friskies()

func _generate_friskies() -> void:
	var frisky_model = preload("res://frisky.tscn")	
	var nb_friskies = 20
	for i in range(nb_friskies):
		var new_frisky = frisky_model.instantiate()
		new_frisky.position.x = randi() % 1000
		new_frisky.position.y = randi() % 1000
		new_frisky.visible = true
		self.add_child(new_frisky)

func _process(delta):
	if $MusicPlayer.playing == false:
		$MusicPlayer.play()
