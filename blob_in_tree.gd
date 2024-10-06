extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprites = [$Sprite2D, $Sprite2D2, $Sprite2D3];
	var theone = randi_range(0, sprites.size())
	for i in range(0, sprites.size()):
		sprites[i].set_visible(i == theone)
