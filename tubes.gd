extends Node2D

@onready var TubeScene = preload("res://tube.tscn")

const tubes_count = 20;
var tubes: Array = [];
const tube_length = 60;
const duration_to_arrive_to_fusee_in_seconds = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tubes = [];
	var previous = self;
	for x in range(0, tubes_count):
		var tube: Node2D = TubeScene.instantiate();
		tube.set_duration_of_avale_per_tube(duration_to_arrive_to_fusee_in_seconds / tubes_count);
		tube.position = Vector2(tube_length, 0);
		tubes.append(tube)
		tube.rotation = 0.2 + randf_range(-0.2, 0.2);
		previous.add_child(tube);
		previous = tube;
	tubes[tubes.size() - 1].set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var player = self.get_parent().get_parent().get_parent().find_child('Player');
	var player_position: Vector2 = player.global_position;
	var distance = _get_distance();
	
	const limit = 2.8
	
	var i = tubes.size() - 1;
	while (distance > tube_length && i >= 0):
		for x in range(i, tubes.size()):
			var ending_position: Vector2 = tubes[i].global_position;
			var angle = ending_position.angle_to_point(player_position);
			var rotation = angle - tubes[x - 1].global_rotation;
			rotation = fposmod(rotation + PI, 2 * PI) - PI;
			#if rotation > limit:
			#	rotation = limit
			#if rotation < -limit:
			#	rotation = -limit
			tubes[x].rotation = rotation;
		distance = _get_distance();
		i = i - 1;
		
	
func _get_distance():
	var player = self.get_parent().get_parent().get_parent().find_child('Player');
	var player_position: Vector2 = player.global_position;
	var ending_position: Vector2 = tubes[tubes.size() - 1].global_position;
	
	return ending_position.distance_to(player_position);


func avale():
	const durationn_per_tube = duration_to_arrive_to_fusee_in_seconds / tubes_count;
	for x in range(0, tubes.size()):
		var timer: Timer = Timer.new()
		timer.wait_time = x * durationn_per_tube;
		timer.one_shot = true;
		timer.connect('timeout', func ():
			tubes[tubes.size() - x - 1].run_avale_animation();
			timer.stop();
			timer.queue_free();
		);
		add_child(timer);
		timer.start();
