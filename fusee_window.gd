extends Node2D

# Drops a tree in the window when the count of cut trees reaches these numbers
const triggers = [1, 4, 7, 10, 14]
var cut_trees = 0

func _ready() -> void:
	var player_shadow = $TreesToCut/PlayerShadow 
	var shadow = 0.5
	player_shadow.modulate.r = shadow
	player_shadow.modulate.g = shadow
	player_shadow.modulate.b = shadow
	
	# The Simple trees resizes themselves, I put it back to original one because I updated it manually in the UI
	const scale = 0.3
	for child in self.get_children():
		if child is SimpleTree:
			child.get_node('SpriteAlive1').scale = Vector2(scale, scale)
	for child in $TreesToCut.get_children():
		if child is SimpleTree:
			child.get_node('SpriteAlive1').scale = Vector2(scale, scale)
			
func _process(delta: float) -> void: 	
	var player = get_parent().get_parent().get_parent().get_parent().find_child('Player')
	var position = player.global_position;
	var player_shadow = $TreesToCut/PlayerShadow 
	player_shadow.global_position.x = 0.2 * position.y + 1084
	var x = player_shadow.global_position.x
	if (x > 1120):
		player_shadow.modulate.a = 1 - (x - 1120)/20
	elif (x < 980):
		player_shadow.modulate.a = 1 - (980 - x)/20
	else:
		player_shadow.modulate.a = 1.0

func has_cut_tree():
	cut_trees += 1;
	if triggers.has(cut_trees):
		var remaining_trees = _get_remaining_trees()
		print_debug(remaining_trees.size())
		var tree_to_drop = remaining_trees[randi_range(0, remaining_trees.size() - 1)]
		tree_to_drop.queue_free();

func _get_remaining_trees():
	var result = [];
	for child in $Node2D.get_children():
		if child is SimpleTree:
			result.append(child)
	return result;
