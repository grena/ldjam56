extends Node2D

class_name BlobInTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var sprites = [$Sprite2D, $Sprite2D2, $Sprite2D3];
	var theone = randi_range(0, sprites.size() - 1)
	for i in range(0, sprites.size()):
		sprites[i].set_visible(i == theone)
	$CPUParticles2D.emitting = true
	
func calmos() -> void:
	$CPUParticles2D.scale_amount_min = 0.5
	$CPUParticles2D.scale_amount_max = 1
	$CPUParticles2D.gravity = Vector2(0, -4)
