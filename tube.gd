extends Node2D

var state = 0;
var duration_of_avale_per_tube;

func set_duration_of_avale_per_tube(value):
	find_child('Timer').wait_time = value / 4
	
func _process(delta: float) -> void:
	pass
	
func _ready() -> void:
	$Sprite2D.set_z_index(1)
	$Sprite2D2.set_z_index(1)
	$Sprite2D3.set_z_index(1)
	$Sprite2D4.set_z_index(1)
	find_child('Sprite2D2').set_visible(false);
	find_child('Sprite2D3').set_visible(false);
	find_child('Sprite2D4').set_visible(false);

func run_avale_animation():
	find_child('Timer').start();

func _on_timer_timeout() -> void:
	self.state = fmod(self.state + 1, 4);
	find_child('Sprite2D').set_visible(self.state == 0);
	find_child('Sprite2D2').set_visible(self.state == 3);
	find_child('Sprite2D3').set_visible(self.state == 2);
	find_child('Sprite2D4').set_visible(self.state == 1);
	if self.state != 0:
		find_child('Timer').start();
		
