extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_generate_friskies()
	# degueu mais marche
	$MusicPlayerStep1.play()
	#$MusicPlayerStep2.play()
	#$MusicPlayerStep2.stop()
	#$MusicPlayerStep3.play()
	#$MusicPlayerStep3.stop()

func _generate_friskies() -> void:
	var frisky_model = preload("res://frisky.tscn")	
	var nb_friskies = 20
	for i in range(nb_friskies):
		var new_frisky = frisky_model.instantiate()
		new_frisky.position.x = randi() % 1000
		new_frisky.position.y = randi() % 1000
		new_frisky.visible = true
		self.add_child(new_frisky)

func _get_level() -> int:
	if $CharacterBody2D.FUEL > 10:
		return 3
	elif $CharacterBody2D.FUEL > 5:
		return 2
	else:
		return 1

func _process(delta):
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
