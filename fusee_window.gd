extends Node2D

# Drops a tree in the window when the count of cut trees reaches these numbers
const triggers = [1, 4, 7, 10, 14]
var cut_trees = 0

@onready var TreesToCut = $TreesToCut;
@onready var PlayerShadow = $TreesToCut/PlayerShadow;
@onready var RealyPlayer = get_parent().get_parent().get_parent().get_parent().find_child('Player')

func _ready() -> void:
	var shadow = 0.5
	PlayerShadow.modulate.r = shadow
	PlayerShadow.modulate.g = shadow
	PlayerShadow.modulate.b = shadow
	
	# The Simple trees resizes themselves, I put it back to original one because I updated it manually in the UI
	const scale = 0.3
	for child in self.get_children():
		if child is SimpleTree:
			child.get_node('SpriteAlive1').scale = Vector2(scale, scale)
	for child in TreesToCut.get_children():
		if child is SimpleTree:
			child.get_node('SpriteAlive1').scale = Vector2(scale, scale)
			
func _process(delta: float) -> void:
	var player = RealyPlayer
	var position = player.global_position;
	PlayerShadow.global_position.x = 0.2 * position.y + 1084
	var x = PlayerShadow.global_position.x
	if (x > 1120):
		PlayerShadow.modulate.a = 1 - (x - 1120)/20
	elif (x < 980):
		PlayerShadow.modulate.a = 1 - (980 - x)/20
	else:
		PlayerShadow.modulate.a = 1.0

func has_cut_tree():
	cut_trees += 1;
	if triggers.has(cut_trees):
		var remaining_trees = _get_remaining_trees()
		var tree_to_drop = remaining_trees[randi_range(0, remaining_trees.size() - 1)]
		tree_to_drop.queue_free();

func _get_remaining_trees():
	var result = [];
	for child in TreesToCut.get_children():
		if child is SimpleTree:
			result.append(child)
	return result;
