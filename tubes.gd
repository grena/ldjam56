extends Node2D

@onready var TubeScene = preload("res://tube.tscn")

const tubes_count = 20;
var tubes: Array = [];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tubes = [];
	var previous = self;
	for x in range(0, tubes_count):
		var tube: Node2D = TubeScene.instantiate();
		tube.position = Vector2(20, 0);
		tubes.append(tube)
		previous.add_child(tube);
		previous = tube;
	tubes[tubes.size() - 1].set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var player = self.get_parent().find_child('CharacterBody2D');
	var player_position: Vector2 = player.global_position;
	var distance = _get_distance();
	
	var i = tubes.size() - 1;
	while (distance > 20 && i >= 0):
		var ending_position: Vector2 = tubes[i].global_position;
		var angle = ending_position.angle_to_point(player_position);
		for x in range(i, tubes.size()):
			tubes[x].global_rotation = angle;
		distance = _get_distance();
		i = i - 1;
		
	
func _get_distance():
	var player = self.get_parent().find_child('CharacterBody2D');
	var player_position: Vector2 = player.global_position;
	var ending_position: Vector2 = tubes[tubes.size() - 1].global_position;
	
	return ending_position.distance_to(player_position);
