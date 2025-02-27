extends Node2D

const limit = 2000
const asset_count = 300

@onready var Floor0 = preload('res://assets/floor0.png')
@onready var Floor1 = preload('res://assets/floor1.png')
@onready var Floor2 = preload('res://assets/floor2.png')
@onready var Floor3 = preload('res://assets/floor3.png')
@onready var Floor4 = preload('res://assets/floor4.png')
@onready var Floor5 = preload('res://assets/floor5.png')
@onready var Floor6 = preload('res://assets/floor6.png')
@onready var Floor7 = preload('res://assets/floor7.png')
@onready var Floor8 = preload('res://assets/floor8.png')
@onready var Floor9 = preload('res://assets/floor9.png')
@onready var Floor10 = preload('res://assets/floor10.png')
@onready var Floor11 = preload('res://assets/floor11.png')
@onready var Floor12 = preload('res://assets/floor12.png')

@onready var Oil1 = preload('res://assets/oil1.png');
@onready var Oil2 = preload('res://assets/oil2.png');
@onready var Oil3 = preload('res://assets/oil3.png');
@onready var Oil4 = preload('res://assets/oil4.png');
@onready var Oil5 = preload('res://assets/oil5.png');
@onready var Oil6 = preload('res://assets/oil6.png');

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in range(0, asset_count):
		var deco = Sprite2D.new();
		var floors = [Floor0, Floor1, Floor2, Floor3, Floor4, Floor5, Floor6, Floor7, Floor8, Floor9, Floor10, Floor11, Floor12];
		deco.texture = floors[randi_range(0, floors.size() - 1)];
		deco.scale = Vector2(0.5, 0.5)
		deco.global_position = Vector2(
			randf_range(-limit, limit),
			randf_range(-limit, limit)
		);
		add_child(deco);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_oil(position) -> void:
	var deco = Sprite2D.new();
	var floors = [Oil1, Oil2, Oil3, Oil4, Oil5, Oil6];
	deco.texture = floors[randi_range(0, floors.size() - 1)];
	var scale = randf_range(1.0, 1.5)
	deco.scale = Vector2(scale, scale)
	deco.global_position = position + Vector2(0, 100);
	deco.modulate.a = randf_range(0.8, 1.0)
	add_child(deco);
