extends Node2D

class_name SimpleTree

@onready var BlobInTreeScene = preload("res://blob_in_tree.tscn")

var MAX_HEIGHT_VARIATION = 0.05
var MIN_HEIGHT_VARIATION = 0.15
var COLOR_VARIATION = 0.3

var tree_sprite_var1 : Sprite2D
var tree_sprite_var2 : Sprite2D

var tree_sprite : Sprite2D
var original_color : Color

var original_scale = Vector2(1, 1)

func _ready() -> void:
	var sprites = [$SpriteAlive1]
	for i in sprites:
		i.visible = false
	tree_sprite = sprites[0]
	tree_sprite.visible = true
	_add_blobs_to_sprite(tree_sprite)
	var variation = randf_range(MIN_HEIGHT_VARIATION, MAX_HEIGHT_VARIATION)
	tree_sprite.scale.y += variation
	tree_sprite.scale.x += variation
	original_color = Color(1 - randf_range(0, COLOR_VARIATION), 1 - randf_range(0, COLOR_VARIATION), 1 - randf_range(0, COLOR_VARIATION), 1.0)
	tree_sprite.modulate = original_color
	original_scale = tree_sprite.scale
	
func _add_blobs_to_sprite(sprite: Sprite2D):
	if sprite.name == 'SpriteAlive1':
		var number_of_blob = randi_range(2,5)
		for x in number_of_blob:
			var blob: Node2D = BlobInTreeScene.instantiate()
			var center = Vector2(0, -480)
			var angle = 2 * PI / number_of_blob * x
			var distance = randf_range(50, 200)
			blob.position = center + Vector2(
				sin(angle) * distance,
				cos(angle) * distance
			)
			blob.rotation = randf_range(0, 2*PI)
			var scale = randf_range(0.5, 0.8)
			blob.scale = Vector2(scale, scale)
			sprite.add_child(blob)
